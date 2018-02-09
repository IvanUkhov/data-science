import numpy as np

from scipy import sparse
from sklearn.metrics.pairwise import cosine_similarity


class NearestNeighbor:
    def __init__(self, rating_data, similarity_data,
                 proxy_encoder=None, target_encoder=None):
        self.rating_data = rating_data
        self.similarity_data = similarity_data
        self.proxy_encoder = proxy_encoder
        self.target_encoder = target_encoder

    def recommend(self, origin, proxy_count=10, target_count=10):
        if self.proxy_encoder:
            origin = self.proxy_encoder.transform([origin])[0]
        similarities = self.similarity_data[origin, :].todense()
        proxies = _choose(np.argsort(-similarities, axis=1), proxy_count,
                          lambda proxy: origin != proxy)
        similarities = self.similarity_data[origin, proxies]
        ratings = self.rating_data[proxies, :]
        scores = similarities.dot(ratings).todense()
        targets = _choose(np.argsort(-scores, axis=1), target_count,
                          lambda target: not self.rating_data[origin, target])
        if self.target_encoder:
            targets = self.target_encoder.inverse_transform(targets)
        return targets


class Rating:
    def __init__(self, rating_data, proxy_column, target_column, shape):
        indices = (rating_data[proxy_column], rating_data[target_column])
        self.data = sparse.csr_matrix((rating_data['rating'], indices),
                                      shape=shape)


class Similarity:
    def __init__(self, rating_data, metric='cosine'):
        if metric == 'cosine':
            self.data = cosine_similarity(rating_data, dense_output=False)


def _choose(items, count, condition):
    chosen = []
    for item in np.nditer(items):
        if condition(item):
            chosen.append(item)
            if len(chosen) == count:
                break
    return chosen
