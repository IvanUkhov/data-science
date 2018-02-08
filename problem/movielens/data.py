import numpy as np
import pandas as pd

from sklearn.model_selection import train_test_split


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
        data.drop('timestamp', axis=1, inplace=True)
        return Rating(data)

    def __init__(self, data):
        self.data = data

    def split(self, first=8, second=2, random_state=42):
        test_size = second / (first + second)
        first, second = train_test_split(test_size=test_size, shuffle=True,
                                         random_state=random_state)
        return Rating(first), Rating(second)
