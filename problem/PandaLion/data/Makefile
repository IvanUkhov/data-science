a := lion
b := panda

all: train test

train: ${a}_train.tfrecords ${b}_train.tfrecords

test: ${a}_test.tfrecords ${b}_test.tfrecords

${a}_%.tfrecords ${b}_%.tfrecords: ${a}/.done ${b}/.done
	docker exec -it ${name} \
		python source/build_data.py \
		--X_input_dir data/${a}/images/$* \
		--Y_input_dir data/${b}/images/$* \
		--X_output_file data/${a}_$*.tfrecords \
		--Y_output_file data/${b}_$*.tfrecords

%/.done:
	$(MAKE) -C $*

.PHONY: all test train
