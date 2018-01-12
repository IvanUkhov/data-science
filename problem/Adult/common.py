import pandas as pd


def feature_names():
    return [
        'Age',
        'Work class',
        'Final sampling weight',
        'Education',
        'Education number',
        'Marital status',
        'Occupation',
        'Relationship',
        'Race',
        'Sex',
        'Capital gain',
        'Capital loss',
        'Hours per week',
        'Native country',
        'Income',
    ]

def load_dataset(path):
    data = pd.read_csv(path, names=feature_names(), sep=r'\s*,\s*',
                       engine='python', skiprows=[0], na_values='?')
    data['Income'] = data['Income'].map({'<=50K.': 'Low', '>50K.': 'High'})
    return data
