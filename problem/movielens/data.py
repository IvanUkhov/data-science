import pandas as pd


class Data:
    def value_counts(self):
        return {column: self.data[column].nunique() for column in self.data.columns}


class Movie(Data):
    def load(path='data/movies.csv'):
        return Movie(pd.read_csv(path))

    def __init__(self, data):
        self.data = data

    def describe(self, ids, column='title'):
        return self.data.loc[ids][column].values.tolist()


class Rating(Data):
    def load(path='data/ratings.csv'):
        data = pd.read_csv(path)
        data['timestamp'] = pd.to_datetime(data['timestamp'], unit='s')
        return Rating(data)

    def __init__(self, data):
        self.data = data
