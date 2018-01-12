import pandas as pd


def feature_names():
    return [
        'Age',
        'WorkClass',
        'FinalSamplingWeight',
        'Education',
        'EducationNumber',
        'MaritalStatus',
        'Occupation',
        'Relationship',
        'Race',
        'Sex',
        'CapitalGain',
        'CapitalLoss',
        'HoursPerWeek',
        'NativeCountry',
        'Income',
    ]

def load_dataset(path, **arguments):
    data = pd.read_csv(path, names=feature_names(), sep=r'\s*,\s*',
                       engine='python', na_values='?', index_col=False,
                       **arguments)
    data['Income'] = data['Income'].map({
        '<=50K.': 'Low',
        '<=50K': 'Low',
        '>50K.': 'High',
        '>50K': 'High',
    })
    return data
