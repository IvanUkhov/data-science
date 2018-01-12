import pandas as pd

def feature_names():
    return [
        'Age',
        'Workclass',
        'fnlwgt',
        'Education',
        'Education-Num',
        'Marital Status',
        'Occupation',
        'Relationship',
        'Race',
        'Sex',
        'Capital Gain',
        'Capital Loss',
        'Hours per week',
        'Country',
        'Target',
    ]

def load_dataset(path):
    return pd.read_csv(path, names=feature_names(), sep=r'\s*,\s*',
                       engine='python', skiprows=[0], na_values='?')
