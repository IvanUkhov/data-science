source := http://files.grouplens.org/datasets/movielens/ml-latest.zip

files := data.zip

all: ${files}

data.zip:
	curl -L ${source} -o data.zip
	unzip -j data.zip

clean:
	rm -f ${files} *.csv *.txt

.PHONY: all clean
