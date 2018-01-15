import collections
import matplotlib.pyplot as pp
import numpy as np
import pandas as pd

from sklearn.metrics import confusion_matrix
from sklearn.metrics import precision_recall_curve, roc_curve


def balance_dataset(data, column, negative, positive):
    def _extract_that(data, column, value):
        return data[data[column] == value]

    def _choose_that(data, column, value, count):
        index = data[data[column] == value].index
        index = np.random.choice(index, count, replace=False)
        return data.loc[index]

    data_positive = _extract_that(data, column, positive)
    data_negative = _choose_that(data, column, negative, len(data_positive))
    data = pd.concat([data_positive, data_negative])
    data = data.sample(frac=1).reset_index(drop=True)
    return data

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
            'Low',
            'High',
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

def plot_confusion(y_true, y_predicted, y_score):
    _, axes = pp.subplots(1, 3, figsize=(15, 4))
    pp.sca(axes[0])
    plot_confusion_matrix(y_true, y_predicted)
    pp.sca(axes[1])
    plot_precision_recall(y_true, y_score)
    pp.sca(axes[2])
    plot_roc(y_true, y_score)

def plot_confusion_matrix(y_true, y_predicted):
    matrix = confusion_matrix(y_true, y_predicted)
    matrix = matrix / matrix.sum(axis=1)[:, None]
    count = matrix.shape[0]
    pp.imshow(matrix, cmap='Blues')
    pp.xticks(np.arange(count), ['Negative', 'Positive'])
    pp.yticks(np.arange(count), ['Negative', 'Positive'])
    middle = matrix.max() / 2.0
    for i in range(count):
        for j in range(count):
            color = 'white' if matrix[i, j] > middle else 'black'
            pp.text(j, i, '{:.2f}%'.format(100 * matrix[i, j]),
                    horizontalalignment='center', color=color)
    pp.ylabel('True')
    pp.xlabel('Predicted')

def plot_precision_recall(y_true, y_score, t_star=0.5):
    base = (y_true == 1).sum() / len(y_true)
    y, x, t = precision_recall_curve(y_true, y_score)
    i = np.argmin(np.abs(t - t_star))
    pp.step(x, y, where='post')
    pp.plot([0, 1], [base, base], linestyle='--')
    pp.plot(x[i], y[i], marker='o', markersize=10)
    pp.xlabel('Recall')
    pp.ylabel('Precision')
    pp.ylim([0.0, 1.0])
    pp.xlim([0.0, 1.0])

def plot_roc(y_true, y_score, t_star=0.5):
    x, y, t = roc_curve(y_true, y_score)
    i = np.argmin(np.abs(t - t_star))
    pp.step(x, y, where='post')
    pp.plot([0, 1], [0, 1], linestyle='--')
    pp.plot(x[i], y[i], marker='o', markersize=10)
    pp.xlabel('False positive rate')
    pp.ylabel('True positive rate')
    pp.ylim([0.0, 1.0])
    pp.xlim([0.0, 1.0])

def print_confusion(y_true, y_predicted, _):
    def _print(name, value):
        print('{}: {:.2f}%'.format(name, 100 * value))
    matrix = confusion_matrix(y_true, y_predicted)
    true_positive = matrix[1, 1]
    true_negative = matrix[0, 0]
    false_positive = matrix[0, 1]
    false_negative = matrix[1, 0]
    total = true_positive + false_negative + true_negative + false_positive
    _print('Accuracy', (true_positive + true_negative) / total)
    _print('Precision', true_positive / (true_positive + false_positive))
    _print('True negative rate (specificity)',
            true_negative / (true_negative + false_positive))
    _print('True positive rate (sensitivity, recall)',
            true_positive / (true_positive + false_negative))
