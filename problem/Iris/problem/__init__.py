import pandas as pd

from sklearn.datasets import load_iris


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
