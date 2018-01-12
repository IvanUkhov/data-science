name := adult

source := https://archive.ics.uci.edu/ml/machine-learning-databases/${name}

start: data
	docker run -it --rm --name ${name} -w /problem \
		-v "${PWD}:/problem" -v "${PWD}/../../package:/package" \
		-p 6006:6006 -p 8888:8888 tensorflow/tensorflow:latest-py3

shell:
	docker exec -it ${name} /bin/bash

install:
	docker exec -it ${name} make -C /package
	docker exec -it ${name} jupyter nbextension install /package/facets/source/facets-dist/

data:
	mkdir -p data
	curl -L ${source}/${name}.data -o data/major.csv
	curl -L ${source}/${name}.test -o data/minor.csv

.PHONY: install start shell
