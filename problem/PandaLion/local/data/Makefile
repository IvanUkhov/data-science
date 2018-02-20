files := \
	${x}_train.tfrecords ${x}_test.tfrecords \
	${y}_train.tfrecords ${y}_test.tfrecords

all: ${files}

${x}_%.tfrecords ${y}_%.tfrecords: ${x}/.done ${y}/.done
	docker exec -it ${name} \
		python source/build_data.py \
		--X_input_dir data/${x}/images/$* \
		--Y_input_dir data/${y}/images/$* \
		--X_output_file data/${x}_$*.tfrecords \
		--Y_output_file data/${y}_$*.tfrecords

%/.done:
	$(MAKE) -C $*

.PHONY: all
