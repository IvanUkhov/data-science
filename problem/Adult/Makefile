name := adult

source := https://archive.ics.uci.edu/ml/machine-learning-databases

start: data
	docker run -it --rm --name ${name} -v ${PWD}:/work -w /work \
		-p 6006:6006 -p 8888:8888 tensorflow/tensorflow:latest-py3

shell:
	docker exec -it ${name} /bin/bash

install: facets
	jupyter nbextension install facets/facets-dist/

facets:
	apt-get update
	apt-get install -y git
	git clone https://github.com/PAIR-code/facets

data:
	mkdir -p data
	curl -L ${source}/${name}/${name}.data -o data/major.csv
	curl -L ${source}/${name}/${name}.test -o data/minor.csv

.PHONY: install start shell
