include ../problem.mk
$(eval $(call problem,movielens))

source := http://files.grouplens.org/datasets/movielens/ml-latest-small.zip

data:
	mkdir -p data
	curl -L ${source} -o data/data.zip
	cd data && unzip -j data.zip
