from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.pipeline import Pipeline

from sklearn.preprocessing import LabelEncoder


class Builder:
    def __init__(self):
        self.steps = []

    def build(self):
        return Pipeline(self.steps)

    def encode(self, column):
        return self._push('encode', column, Encoder(column))

    def _name(self, action, column):
        return '{}_{}'.format(action, column)

    def _push(self, action, column, transformer):
        self.steps.append((self._name(action, column), transformer))
        return self


class Transformer(BaseEstimator, TransformerMixin):
    def fit(self, x, y=None):
        return self


class Encoder(Transformer):
    def __init__(self, column):
        self.column = column
        self.encoder = LabelEncoder()

    def fit(self, x):
        self.encoder.fit(x[self.column])
        return self

    def transform(self, x):
        x[self.column] = self.encoder.transform(x[self.column])
        return x
