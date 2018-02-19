include ../problem.mk
$(eval $(call problem,pandalion))

export x := lion
export y := panda

model_path := checkpoints
trained_model_path := pretrained

data: source
	$(MAKE) -C data

source:
	git clone https://github.com/vanhuyz/CycleGAN-TensorFlow source

train: data ${model_path}
	model=$$(find ${model_path} -type d ! -path ${model_path} | head -1); \
	flags+=" --X data/${x}_train.tfrecords"; \
	flags+=" --Y data/${y}_train.tfrecords"; \
	[ ! -z "$${model}" ] && flags+=" --load_model $${model}"; \
	docker exec -it ${name} python source/train.py $${flags}

export: ${trained_model_path}/${x}2${y}.pb

infer: ${trained_model_path}/${x}2${y}.pb
	input=$${INPUT:=data/lion/images/test/0cd9b1229efff99513cd.jpg}; \
	output=$${OUTPUT:=${x}2${y}.jpg}; \
	flags+=" --model $<"; \
	flags+=" --image_size 256"; \
	flags+=" --input $${input}"; \
	flags+=" --output $${output}"; \
	docker exec -it ${name} python source/inference.py $${flags}

board: board-setup

board-setup: ${model_path}
	docker exec -it ${name} rm -f /tmp/model
	docker exec -it ${name} ln -s /problem/${model_path} /tmp/model
	
${trained_model_path}/${x}2${y}.pb:
	model=$$(find ${model_path} -type d ! -path ${model_path} | head -1); \
	flags+=" --checkpoint_dir $${model}"; \
	flags+=" --image_size 256"; \
	flags+=" --XtoY_model ${x}2${y}.pb"; \
	flags+=" --YtoX_model ${y}2${x}.pb"; \
	docker exec -it ${name} python source/export_graph.py $${flags}

${model_path}:
	mkdir -p ${model_path}

.PHONY: board-setup data export infer train
