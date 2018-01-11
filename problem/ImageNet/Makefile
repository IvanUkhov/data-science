name := imagenet

source_url := https://github.com/googlecodelabs/tensorflow-for-poets-2
images_url := http://download.tensorflow.org/example_images/flower_photos.tgz

source := source
architecture := mobilenet_0.50_224

start:
	docker run -it --rm --name ${name} -v ${PWD}:/work -w /work \
		-p 6006:6006 -p 8888:8888 tensorflow/tensorflow:latest-py3

setup:
	git clone ${source_url} ${source}
	curl ${images_url} | tar xz -C ${source}/tf_files

shell:
	docker exec -it ${name} /bin/bash

board:
	tensorboard --logdir ${source}/tf_files/training_summaries

retrain:
	cd ${source} && python -m scripts.retrain \
		--bottleneck_dir=tf_files/bottlenecks \
		--how_many_training_steps=500 \
		--model_dir=tf_files/models/ \
		--summaries_dir=tf_files/training_summaries/${architecture} \
		--output_graph=tf_files/retrained_graph.pb \
		--output_labels=tf_files/retrained_labels.txt \
		--architecture=${architecture} \
		--image_dir=tf_files/flower_photos

classify:
	cd ${source} && python -m scripts.label_image \
		--graph=tf_files/retrained_graph.pb  \
		--image=tf_files/flower_photos/daisy/21652746_cc379e0eea_m.jpg

.PHONY: start setup shell board retrain classify
