import numpy as np

from scipy import sparse
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.preprocessing import LabelEncoder


class NearestNeighbor:
    def __init__(self, sources, targets, ratings):
        self.source_encoder = LabelEncoder()
        self.target_encoder = LabelEncoder()
        encoded_sources = self.source_encoder.fit_transform(sources)
        encoded_targets = self.target_encoder.fit_transform(targets)
        n_sources = len(self.source_encoder.classes_)
        n_targets = len(self.target_encoder.classes_)
        self.rating = Rating(encoded_sources, encoded_targets, ratings,
                             shape=(n_sources, n_targets))
        self.similarity = Similarity(self.rating)

    def recommend(self, source, count=10, neighbor_count=10):
        source = self.source_encoder.transform([source])[0]
        ratings = self._predict_ratings(source, neighbor_count)
        targets = _choose(np.argsort(-ratings, axis=1), count,
                          lambda target: not self.rating[source, target])
        return self.target_encoder.inverse_transform(targets), \
               ratings[0, targets].tolist()[0]

    def recommend_neighbors(self, source, count=10):
        source = self.source_encoder.transform([source])[0]
        neighbors, similarities = self._find_neighbors(source, count)
        return self.source_encoder.inverse_transform(neighbors), \
               similarities.tolist()[0]

    def _find_neighbors(self, source, count):
        similarities = self.similarity[source, :].todense()
        neighbors = _choose(np.argsort(-similarities, axis=1), count,
                            lambda neighbor: source != neighbor)
        return neighbors, similarities[0, neighbors]

    def _predict_ratings(self, source, neighbor_count):
        neighbors, _ = self._find_neighbors(source, neighbor_count)
        similarities = self.similarity[source, neighbors]
        ratings = self.rating[neighbors, :]
        return np.divide(similarities.dot(ratings),
                         np.abs(similarities).dot(ratings > 0))


class Rating:
    def __init__(self, sources, targets, ratings, shape):
        self.data = sparse.csr_matrix(
            (ratings, (sources, targets)), shape=shape)

    def __getitem__(self, key):
        return self.data.__getitem__(key)


class Similarity:
    def __init__(self, rating, metric='cosine'):
        if metric == 'cosine':
            self.data = cosine_similarity(rating.data, dense_output=False)

    def __getitem__(self, key):
        return self.data.__getitem__(key)


def _choose(collection, count, condition):
    chosen = []
    for item in np.nditer(collection):
        if condition(item):
            chosen.append(item)
            if len(chosen) == count:
                break
    return chosen
