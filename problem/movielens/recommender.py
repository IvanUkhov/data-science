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

    def recommend_proxies(self, proxy, count=10):
        proxy = self.proxy_encoder.transform([proxy])[0]
        proxies, similarities = self._recommend_proxies(proxy, count)
        return self.proxy_encoder.inverse_transform(proxies), similarities

    def recommend_targets(self, proxy, count=10, proxy_count=10):
        proxy = self.proxy_encoder.transform([proxy])[0]
        targets, ratings = self._recommend_targets(proxy, count, proxy_count)
        return self.target_encoder.inverse_transform(targets), ratings

    def _recommend_proxies(self, proxy, count):
        similarities = self.similarity.data[proxy, :].todense()
        proxies = _choose(np.argsort(-similarities, axis=1), count,
                          lambda another_proxy: proxy != another_proxy)
        return proxies, similarities[0, proxies].tolist()[0]

    def _recommend_targets(self, proxy, count, proxy_count):
        proxies, _ = self._recommend_proxies(proxy, proxy_count)
        similarities = self.similarity.data[proxy, proxies]
        ratings = self.rating.data[proxies, :]
        ratings = np.divide(similarities.dot(ratings),
                            np.abs(similarities).dot(ratings > 0))
        targets = _choose(np.argsort(-ratings, axis=1), count,
                          lambda target: not self.rating.data[proxy, target])
        return targets, ratings[0, targets].tolist()[0]


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
