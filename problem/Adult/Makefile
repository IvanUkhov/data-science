name := adult

source := https://archive.ics.uci.edu/ml/machine-learning-databases/${name}

start:
	docker run -it --rm --name ${name} -w /problem \
		-v "$(shell pwd):/problem" -v "$(shell pwd)/../../package:/package" \
		-p 6006:6006 -p 8888:8888 tensorflow/tensorflow:latest-py3

setup: data
	docker exec -it ${name} make -C /package

shell:
	docker exec -it ${name} /bin/bash

board:
	docker exec -it ${name} tensorboard --logdir=/problem/model

data:
	mkdir -p data
	curl -L ${source}/${name}.data -o data/major.csv
	curl -L ${source}/${name}.test -o data/minor.csv

.PHONY: board setup shell start
