include ../problem.mk
$(eval $(call problem,pandalion,torch))

data:
	$(MAKE) -C data

source:
	git clone https://github.com/junyanz/CycleGAN source

train: source
	docker exec -it pandalion \
		/bin/bash -c 'cd source; DATA_ROOT=../data name=lion2panda gpu=0 cudnn=0 th train.lua'

.PHONY: data train
