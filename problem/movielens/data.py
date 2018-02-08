import numpy as np
import pandas as pd


class Data:
    def describe(self):
        def unique(series):
            return series.nunique()

        def missing(series):
            return series.isnull().sum()

        def zero(series):
            return len(series) - np.count_nonzero(series)

        aggregates = self.data.aggregate([unique, missing, zero])
        return self.data.describe().append(aggregates)


class Movie(Data):
    def load(path='data/movies.csv', **arguments):
        return Movie(pd.read_csv(path, **arguments))

    def __init__(self, data):
        data.set_index('movieId', inplace=True)
        self.data = data

    def find(self, ids):
        return self.data.loc[ids]


class Rating(Data):
    def load(path='data/ratings.csv', **arguments):
        data = pd.read_csv(path, **arguments)
        data['timestamp'] = pd.to_datetime(data['timestamp'], unit='s')
        return Rating(data)

    def __init__(self, data):
        self.data = data
