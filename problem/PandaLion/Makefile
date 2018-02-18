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

infer:
	docker exec -it ${name} \
		python source/inference.py \
		--model pretrained/lion2panda.pb \
		--input $${INPUT:=data/lion/images/test/0b1fd4cb410910b79602.jpg} \
		--output $${OUTPUT:=PandaLion.jpg} \
		--image_size 256

.PHONY: data export infer train
