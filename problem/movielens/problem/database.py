import numpy as np
import pandas as pd

from sklearn.model_selection import train_test_split


class Database:
    def describe(self):
        def unique(series):
            return series.nunique()

        def missing(series):
            return series.isnull().sum()

        def zero(series):
            return len(series) - np.count_nonzero(series)

        aggregates = self.data.aggregate([unique, missing, zero])
        return self.data.describe().append(aggregates)


class Movie(Database):
    def load(path='data/movies.csv', **arguments):
        return Movie(pd.read_csv(path, **arguments))

    def __init__(self, data):
        data.set_index('movieId', inplace=True)
        self.data = data

    def find(self, movies):
        return self.data.reindex(movies)


class Rating(Database):
    def load(path='data/ratings.csv', clean=True, **arguments):
        data = pd.read_csv(path, **arguments)
        if clean: data = Rating.clean(data)
        return Rating(data)

    def clean(data):
        data.sort_values(by='timestamp', inplace=True)
        data.drop('timestamp', axis=1, inplace=True)
        data = data.groupby(['userId', 'movieId'])['rating'].agg(['last'])
        data.rename({'last': 'rating'}, axis=1, inplace=True)
        data.reset_index(inplace=True)
        return data

    def __init__(self, data):
        self.data = data

    def find_by_movie(self, movie):
        data = self.data[self.data['movieId'] == movie][['userId', 'rating']]
        data.set_index('userId', inplace=True)
        return data

    def find_by_user(self, user):
        data = self.data[self.data['userId'] == user][['movieId', 'rating']]
        data.set_index('movieId', inplace=True)
        return data

    def split(self, major=8, minor=2, random_state=42):
        test_size = minor / (major + minor)
        major, minor = train_test_split(self.data,
                                        shuffle=True,
                                        test_size=test_size,
                                        random_state=random_state)
        return Rating(major), Rating(minor)
