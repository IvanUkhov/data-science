source := https://archive.ics.uci.edu/ml/machine-learning-databases/adult

files := test.csv train.csv

all: ${files}

test.csv:
	curl -L ${source}/adult.test -o $@

train.csv:
	curl -L ${source}/adult.data -o $@

clean:
	rm -f ${files}

.PHONY: all clean
