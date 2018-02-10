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
        encoded_sources = self.source_encoder.fit_transform(data[0])
        encoded_targets = self.target_encoder.fit_transform(data[1])
        data = (encoded_sources, encoded_targets, data[2])
        self.n_source = len(self.source_encoder.classes_)
        self.n_target = len(self.target_encoder.classes_)
        self.rating = Rating(data, shape=(self.n_source, self.n_target))
        self.mean, self.source_biases, self.target_biases = \
            Baseline._compute(self.rating.data, **self.options)
        return self

    @staticmethod
    def _compute(data, **options):
        n_epoch = options.get('n_epoch', 10)
        l_source = options.get('l_source', 15)
        l_target = options.get('l_target', 15)
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

    def predict(self, source, target):
        source = self.source_encoder.transform([source])[0]
        target = self.target_encoder.transform([target])[0]
        return self.mean + \
               self.source_biases[source] + \
               self.target_biases[target]


class NearestNeighbor(Baseline):
    def __init__(self, **options):
        super(NearestNeighbor, self).__init__(**options)

    def fit(self, data):
        super(NearestNeighbor, self).fit(data)
        self.similarity = Similarity(self.rating)
        return self

    def recommend(self, source, n_target=10, n_neighbors=10):
        source = self.source_encoder.transform([source])[0]
        ratings = self._predict_ratings(source, n_neighbors)
        targets = _choose(n_target, np.argsort(-ratings, axis=1),
                          lambda target: not self.rating[source, target])
        return self.target_encoder.inverse_transform(targets), \
               ratings[0, targets].tolist()[0]

    def recommend_neighbors(self, source, n_neighbors=10):
        source = self.source_encoder.transform([source])[0]
        neighbors, similarities = self._find_neighbors(source, n_neighbors)
        return self.source_encoder.inverse_transform(neighbors), \
               similarities.tolist()[0]

    def _find_neighbors(self, source, n_neighbors):
        similarities = self.similarity[source, :].todense()
        neighbors = _choose(n_neighbors, np.argsort(-similarities, axis=1),
                            lambda neighbor: source != neighbor)
        return neighbors, similarities[0, neighbors]

    def _predict_ratings(self, source, n_neighbors):
        neighbors, _ = self._find_neighbors(source, n_neighbors)
        similarities = self.similarity[source, neighbors]
        ratings = self.rating[neighbors, :]
        return np.divide(similarities.dot(ratings),
                         np.abs(similarities).dot(ratings > 0))


class Rating:
    def __init__(self, data, shape):
        data = (data[2], (data[0], data[1]))
        self.data = sparse.csr_matrix(data, shape=shape)

    def __getitem__(self, key):
        return self.data.__getitem__(key)


class Similarity:
    def __init__(self, rating, metric='cosine'):
        if metric == 'cosine':
            self.data = cosine_similarity(rating.data, dense_output=False)

    def __getitem__(self, key):
        return self.data.__getitem__(key)


def _choose(n, collection, condition):
    chosen = []
    for item in np.nditer(collection):
        if condition(item):
            chosen.append(item)
            if len(chosen) == n:
                break
    return chosen
