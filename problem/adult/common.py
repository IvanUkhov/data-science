import collections
import matplotlib.pyplot as pp
import numpy as np
import pandas as pd


def column_defaults():
    defaults = []
    categorical_names = column_variants().keys()
    for name in column_names():
        defaults.append((name, ['' if name in categorical_names else 0]))
    return collections.OrderedDict(defaults)

def column_names():
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

def column_variants():
    return {
        'Education': [
            '10th',
            '11th',
            '12th',
            '1st-4th',
            '5th-6th',
            '7th-8th',
            '9th',
            'Assoc-acdm',
            'Assoc-voc',
            'Bachelors',
            'Doctorate',
            'HS-grad',
            'Masters',
            'Preschool',
            'Prof-school',
            'Some-college',
        ],
        'Income': [
            'High',
            'Low',
        ],
        'MaritalStatus': [
            'Divorced',
            'Married-AF-spouse',
            'Married-civ-spouse',
            'Married-spouse-absent',
            'Never-married',
            'Separated',
            'Widowed',
        ],
        'NativeCountry': [
            'Cambodia',
            'Canada',
            'China',
            'Columbia',
            'Cuba',
            'Dominican-Republic',
            'Ecuador',
            'El-Salvador',
            'England',
            'France',
            'Germany',
            'Greece',
            'Guatemala',
            'Haiti',
            'Holand-Netherlands',
            'Honduras',
            'Hong',
            'Hungary',
            'India',
            'Iran',
            'Ireland',
            'Italy',
            'Jamaica',
            'Japan',
            'Laos',
            'Mexico',
            'Nicaragua',
            'Outlying-US(Guam-USVI-etc)',
            'Peru',
            'Philippines',
            'Poland',
            'Portugal',
            'Puerto-Rico',
            'Scotland',
            'South',
            'Taiwan',
            'Thailand',
            'Trinadad&Tobago',
            'United-States',
            'Vietnam',
            'Yugoslavia',
        ],
        'Occupation': [
            'Adm-clerical',
            'Armed-Forces',
            'Craft-repair',
            'Exec-managerial',
            'Farming-fishing',
            'Handlers-cleaners',
            'Machine-op-inspct',
            'Other-service',
            'Priv-house-serv',
            'Prof-specialty',
            'Protective-serv',
            'Sales',
            'Tech-support',
            'Transport-moving',
        ],
        'Relationship': [
            'Husband',
            'Not-in-family',
            'Other-relative',
            'Own-child',
            'Unmarried',
            'Wife',
        ],
        'Race': [
            'Amer-Indian-Eskimo',
            'Asian-Pac-Islander',
            'Black',
            'Other',
            'White',
        ],
        'Sex': [
            'Female',
            'Male',
        ],
        'WorkClass': [
            'Federal-gov',
            'Local-gov',
            'Never-worked',
            'Private',
            'Self-emp-inc',
            'Self-emp-not-inc',
            'State-gov',
            'Without-pay',
        ],
    }

def drop_missing(data):
    data.dropna(inplace=True)
    data.index = pd.RangeIndex(len(data.index))

def load_dataset(path, **arguments):
    data = pd.read_csv(path, names=column_names(), sep=r'\s*,\s*',
                       engine='python', na_values='?', index_col=False,
                       **arguments)
    data['Income'] = data['Income'].map({
        '<=50K.': 'Low',
        '<=50K': 'Low',
        '>50K.': 'High',
        '>50K': 'High',
    })
    return data

def plot_confusion(data, **arguments):
    data = data.astype(float).div(data.sum(axis=1), axis='index')
    pp.imshow(data, cmap='Blues', **arguments)
    pp.xticks(np.arange(len(data)), data.columns)
    pp.yticks(np.arange(len(data)), data.columns)
    middle = data.values.max() / 2.0
    for i in range(len(data)):
        for j in range(len(data)):
            color = 'white' if data.iloc[i, j] > middle else 'black'
            pp.text(j, i, '{:.2f}%'.format(100 * data.iloc[i, j]),
                    horizontalalignment='center', color=color)
    pp.ylabel('Observed')
    pp.xlabel('Predicted')

def print_confusion(data):
    def _print(name, value):
        print('{}: {:.2f}%'.format(name, 100 * value))
    true_positive = data.iloc[1, 1]
    true_negative = data.iloc[0, 0]
    false_positive = data.iloc[0, 1]
    false_negative = data.iloc[1, 0]
    total = true_positive + false_negative + true_negative + false_positive
    _print('Accuracy', (true_positive + true_negative) / total)
    _print('Precision', true_positive / (true_positive + false_positive))
    _print('True negative rate (specificity)',
            true_negative / (true_negative + false_positive))
    _print('True positive rate (sensitivity, recall)',
            true_positive / (true_positive + false_negative))
