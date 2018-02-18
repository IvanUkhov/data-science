include ../problem.mk
$(eval $(call problem,pandalion))

data: source
	$(MAKE) -C data

source:
	git clone https://github.com/vanhuyz/CycleGAN-TensorFlow source

train: data
	docker exec -it ${name} ln -fs /problem/checkpoints /tmp/model
	docker exec -it ${name} \
		python source/train.py  \
		--X data/lion_train.tfrecords \
		--Y data/panda_train.tfrecords

.PHONY: data
