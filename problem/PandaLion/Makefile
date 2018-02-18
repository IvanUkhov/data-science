include ../problem.mk
$(eval $(call problem,pandalion))

export x := lion
export y := panda

data: source
	$(MAKE) -C data

source:
	git clone https://github.com/vanhuyz/CycleGAN-TensorFlow source

train: data
	docker exec -it ${name} ln -fs /problem/checkpoints /tmp/model
	docker exec -it ${name} \
		python source/train.py  \
		--X data/${x}_train.tfrecords \
		--Y data/${y}_train.tfrecords

export: pretrained/${x}2{y}.pb

infer: pretrained/${x}2${y}.pb
	input=$${INPUT:=data/lion/images/test/0b1fd4cb410910b79602.jpg}; \
	output=$${OUTPUT:=${x}2${y}.jpg}; \
	docker exec -it ${name} \
		python source/inference.py \
		--model $< \
		--input "$${input}" \
		--output "$${output}" \
		--image_size 256
	
pretrained/${x}2${y}.pb:
	docker exec -it ${name} \
		python source/export_graph.py \
		--checkpoint_dir $$(find checkpoints -type d ! -path checkpoints | head -1) \
		--XtoY_model ${x}2${y}.pb \
		--YtoX_model ${y}2${x}.pb \
		--image_size 256

.PHONY: data export infer train
