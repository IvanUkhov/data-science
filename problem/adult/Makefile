include ../problem.mk
$(eval $(call problem,adult))

source := https://archive.ics.uci.edu/ml/machine-learning-databases/${name}

setup: data

data:
	mkdir -p data
	curl -L ${source}/${name}.data -o data/train.csv
	curl -L ${source}/${name}.test -o data/test.csv
