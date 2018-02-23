FROM tensorflow/tensorflow:latest-py3

RUN apt-get update && apt-get install -y \
  git \
  graphviz

RUN pip install \
  graphviz \
  seaborn \
  surprise

RUN git clone --recursive https://github.com/chain-rule/IFacets.git /tmp/IFacets
RUN make -C /tmp/IFacets
