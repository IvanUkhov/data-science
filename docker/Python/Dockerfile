FROM tensorflow/tensorflow:latest-py3

RUN apt-get update && apt-get install -y git

RUN git clone --recursive https://github.com/chain-rule/IFacets.git /tmp/IFacets
RUN make -C /tmp/IFacets

RUN pip install seaborn surprise

CMD ["/run_jupyter.sh", "--allow-root"]
