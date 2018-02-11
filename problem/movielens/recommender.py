import numpy as np

from scipy import sparse
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.preprocessing import LabelEncoder


class Baseline:
    def __init__(self, **options):
        self.source_encoder = LabelEncoder()
        self.target_encoder = LabelEncoder()
        self.options = options

    def fit(self, data):
        n_epoch = self.options.get('n_epoch', 10)
        l_source = self.options.get('l_source', 15)
        l_target = self.options.get('l_target', 15)
        encoded_sources = self.source_encoder.fit_transform(data[0])
        encoded_targets = self.target_encoder.fit_transform(data[1])
        data = (encoded_sources, encoded_targets, data[2])
        self.n_source = len(self.source_encoder.classes_)
        self.n_target = len(self.target_encoder.classes_)
        self.rating = Rating(data, shape=(self.n_source, self.n_target))
        self.mean, self.source_biases, self.target_biases = \
            Baseline._compute(self.rating.data, n_epoch, l_source, l_target)
        return self

    def predict(self, source, target):
        source, target = self._encode(source, target)
        return self.mean + \
               self.source_biases[source] + \
               self.target_biases[target]

    def _encode(self, source=None, target=None):
        if source: source = self.source_encoder.transform([source])[0]
        if target: target = self.target_encoder.transform([target])[0]
        return source, target

    @staticmethod
    def _compute(data, n_epoch, l_source, l_target):
        n_source, n_target = data.shape
        index = data.nonzero()
        mean = data[index].mean()
        centered = np.squeeze(np.asarray(data[index])) - mean
        source_biases = np.zeros(n_source)
        target_biases = np.zeros(n_target)
        source_counts = np.bincount(index[0])
        target_counts = np.bincount(index[1])
        for _ in range(n_epoch):
            target_biases[:] = np.divide(
                np.bincount(index[1], centered - source_biases[index[0]]),
                l_target + target_counts)
            source_biases[:] = np.divide(
                np.bincount(index[0], centered - target_biases[index[1]]),
                l_source + source_counts)
        return mean, source_biases, target_biases


class NearestNeighbor(Baseline):
    def __init__(self, **options):
        super(NearestNeighbor, self).__init__(**options)

    def fit(self, data):
        super(NearestNeighbor, self).fit(data)
        self.similarity = Similarity(self.rating.data, **self.options)
        return self

    def connect(self, source, n_neighbor=10):
        source, _ = self._encode(source=source)
        similarities = self.similarity[source, :].todense()
        neighbors = _choose(
            n_neighbor, np.argsort(-similarities, axis=1),
            lambda neighbor: source != neighbor)
        similarities = np.squeeze(np.asarray(similarities[0, neighbors]))
        neighbors = self.source_encoder.inverse_transform(neighbors)
        return neighbors, similarities

    def predict(self, source, target, n_neighbor=10, n_neighbor_min=1):
        source, target = self._encode(source=source, target=target)
        similarities = self.similarity[source, :].todense()
        neighbors = _choose(
            n_neighbor, np.argsort(-similarities, axis=1),
            lambda neighbor: source != neighbor and
                             self.rating[neighbor, target])
        if len(neighbors) < n_neighbor_min:
            return super(NearestNeighbor, self).predict(source, target)
        ratings = self.rating[neighbors, target]
        similarities = self.similarity[source, neighbors]
        return similarities.dot(ratings)[0, 0] / np.sum(np.abs(similarities))


class Matrix:
    def __getitem__(self, key):
        return self.data.__getitem__(key)


class Rating(Matrix):
    def __init__(self, data, shape):
        data = (data[2], (data[0], data[1]))
        self.data = sparse.csr_matrix(data, shape=shape)


class Similarity(Matrix):
    def __init__(self, data, **options):
        metric = options.get('metric', 'cosine')
        if metric == 'cosine':
            self.data = cosine_similarity(data, dense_output=False)


def _choose(n, collection, condition):
    chosen = []
    for item in np.nditer(collection):
        if condition(item):
            chosen.append(item)
            if len(chosen) == n:
                break
    return chosen
