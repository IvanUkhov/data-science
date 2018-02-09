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
        proxies = np.argsort(-similarities, axis=1)[0, :proxy_count]
        proxies = proxies.tolist()[0]
        proxies.remove(origin)
        similarities = self.similarity_data[origin, proxies]
        ratings = self.rating_data[proxies, :]
        scores = similarities.dot(ratings).todense()
        targets = np.argsort(-scores, axis=1)[0, :target_count]
        targets = targets.tolist()[0]
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
