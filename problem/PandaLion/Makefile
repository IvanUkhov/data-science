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

export:
	docker exec -it ${name} \
		python source/export_graph.py \
		--checkpoint_dir $$(find checkpoints -type d ! -path checkpoints | head -1) \
		--XtoY_model lion2panda.pb \
		--YtoX_model panda2lion.pb \
		--image_size 256

.PHONY: data export train
