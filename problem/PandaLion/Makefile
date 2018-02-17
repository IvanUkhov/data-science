include ../problem.mk
$(eval $(call problem,pandalion,torch))

data:
	$(MAKE) -C data

source:
	git clone https://github.com/junyanz/CycleGAN source

train: source
	docker exec -it ${name} \
		/bin/bash -c 'cd source; DATA_ROOT=../data name=${name} gpu=0 cudnn=0 th train.lua'

test: source
	docker exec -it ${name} \
		/bin/bash -c 'cd source; DATA_ROOT=../data name=${name} gpu=0 cudnn=0 phase=test th test.lua'

.PHONY: data test train
