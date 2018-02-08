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

    def recommend(self, id, proxy_count=10, target_count=10):
        if self.proxy_encoder:
            id = self.proxy_encoder.transform([id])[0]
        similarities = self.similarity_data[id, :]
        ids = np.argsort(-similarities.todense(), axis=1)[0, :proxy_count]
        ids = ids.tolist()[0]
        ids.remove(id)
        scores = self.similarity_data[id, ids].dot(self.rating_data[ids, :])
        ids = np.argsort(-scores.todense(), axis=1)[0, :target_count]
        ids = ids.tolist()[0]
        if self.target_encoder:
            ids = self.target_encoder.inverse_transform(ids)
        return ids


class Rating:
    def __init__(self, rating_data, proxy, target, shape):
        self.data = sparse.csr_matrix(
            (rating_data['rating'], (rating_data[proxy], rating_data[target])),
            shape=shape)


class Similarity:
    def __init__(self, rating_data, metric='cosine'):
        if metric == 'cosine':
            self.data = cosine_similarity(rating_data, dense_output=False)
