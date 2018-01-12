import os
import sys

sys.path.append(os.path.join(os.path.dirname(__file__),
                             'source/facets_overview/python'))

import base64

from IPython.core.display import display, HTML
from generic_feature_statistics_generator import GenericFeatureStatisticsGenerator


def display_dive(data, name=None, height=800):
    data = data.to_json(orient='records')
    template = """
    <facets-dive id='dive' height='{height}'></facets-dive>
    <script>
    var data = {data};
    document.querySelector('#dive').data = data;
    </script>
    """
    display(HTML(template.format(data=data, height=height)))

def display_overview(data, name=None, height=800):
    generator = GenericFeatureStatisticsGenerator()
    data = generator.ProtoFromDataFrames([{'name': name, 'table': data}])
    data = base64.b64encode(data.SerializeToString()).decode('utf-8')
    template = """
    <facets-overview id='overview' height='{height}'></facets-overview>
    <script>
    document.querySelector('#overview').protoInput = '{data}';
    </script>"""
    display(HTML(template.format(data=data, height=height)))

def display_preamble():
    template = """
    <style>
    .container { width:100% !important; }
    </style>
    <link rel='import' href='/nbextensions/facets-dist/facets-jupyter.html'>
    """
    display(HTML(template))
