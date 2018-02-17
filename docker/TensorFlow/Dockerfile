FROM tensorflow/tensorflow:latest-py3

ENV IFACETS=https://github.com/chain-rule/IFacets.git
RUN apt-get update && apt-get install -y git
RUN git clone --recursive ${IFACETS} /tmp/IFacets && make -C /tmp/IFacets

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

CMD ["/run_jupyter.sh", "--allow-root"]
