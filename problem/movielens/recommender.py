import numpy as np

from scipy import sparse
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.preprocessing import LabelEncoder


class NearestNeighbor:
    def __init__(self, proxies, targets, ratings):
        self.proxy_encoder = LabelEncoder()
        self.target_encoder = LabelEncoder()
        encoded_proxies = self.proxy_encoder.fit_transform(proxies)
        encoded_targets = self.target_encoder.fit_transform(targets)
        n_proxies = len(self.proxy_encoder.classes_)
        n_targets = len(self.target_encoder.classes_)
        self.rating = Rating(encoded_proxies, encoded_targets, ratings,
                             shape=(n_proxies, n_targets))
        self.similarity = Similarity(self.rating)

    def recommend(self, origin, proxy_count=10, target_count=10):
        origin = self.proxy_encoder.transform([origin])[0]
        similarities = self.similarity.data[origin, :].todense()
        proxies = _choose(np.argsort(-similarities, axis=1), proxy_count,
                          lambda proxy: origin != proxy)
        similarities = self.similarity.data[origin, proxies]
        ratings = self.rating.data[proxies, :]
        scores = similarities.dot(ratings).todense()
        targets = _choose(np.argsort(-scores, axis=1), target_count,
                          lambda target: not self.rating.data[origin, target])
        return self.target_encoder.inverse_transform(targets)


class Rating:
    def __init__(self, proxies, targets, ratings, shape):
        self.data = sparse.csr_matrix((ratings, (proxies, targets)),
                                      shape=shape)


class Similarity:
    def __init__(self, rating, metric='cosine'):
        if metric == 'cosine':
            self.data = cosine_similarity(rating.data, dense_output=False)


def _choose(collection, count, condition):
    chosen = []
    for item in np.nditer(collection):
        if condition(item):
            chosen.append(item)
            if len(chosen) == count:
                break
    return chosen
