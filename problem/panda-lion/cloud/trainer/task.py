import argparse
import os
import tensorflow as tf

from tensorflow.contrib.training.python.training.hparam import HParams


def run(params):
    tf.logging.info('Translation from %s to %s', params.x_name, params.y_name)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--x-name', required=True)
    parser.add_argument('--x-data', required=True)
    parser.add_argument('--y-name', required=True)
    parser.add_argument('--y-data', required=True)
    parser.add_argument('--verbosity', default='INFO')

    arguments = parser.parse_args()

    tf.logging.set_verbosity(arguments.verbosity)
    os.environ['TF_CPP_MIN_LOG_LEVEL'] = str(
        tf.logging.__dict__[arguments.verbosity] / 10)

    run(HParams(**arguments.__dict__))
