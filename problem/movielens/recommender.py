import numpy as np

from scipy import sparse
from sklearn.metrics.pairwise import cosine_similarity


class NearestNeighbor:
    def __init__(self, rating_data, similarity_data,
                 encoder=None, decoder=None):
        self.rating_data = rating_data
        self.similarity_data = similarity_data
        self.encoder = encoder
        self.decoder = decoder

    def recommend(self, id, count=10):
        if self.encoder: id = self.encoder.transform([id])[0]
        index = self.similarity_data[id, :].nonzero()[1]
        weights = self.similarity_data[id, index]
        ratings = self.rating_data[index, :]
        scores = weights.dot(ratings).todense()
        ids = np.argsort(-scores, axis=1)[0, :count].tolist()[0]
        if self.decoder: ids = self.decoder.inverse_transform(ids)
        return ids


class Rating:
    def __init__(self, rating_data, major, minor, shape):
        data = (rating_data['rating'], (rating_data[major], rating_data[minor]))
        self.data = sparse.csr_matrix(data, shape=shape)


class Similarity:
    def __init__(self, rating_data, metric='cosine'):
        if metric == 'cosine':
            self.data = cosine_similarity(rating_data, dense_output=False)
