import pandas as pd

from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split


def load():
    problem = load_iris()
    problem.feature_names = [name.capitalize()
                             for name in problem.feature_names]
    problem.target_names = [name.capitalize()
                            for name in problem.target_names]
    data = pd.DataFrame(problem.target, columns=['Species'])
    data = data.join(pd.DataFrame(problem.data, columns=problem.feature_names))
    data['Species'] = data['Species'].map(
        lambda i: problem.target_names[i]).astype('category')
    return data


def load_split_train_test():
    return split_train_test(load())


def split_feature_target(data):
    target = data.pop('Species')
    return data, target


def split_train_test(data):
    return train_test_split(data, shuffle=True, test_size=0.3)
