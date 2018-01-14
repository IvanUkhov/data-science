define problem
name := $(1)

all: start

board:
	docker exec -it $${name} tensorboard --logdir=/tmp/model

setup:
	docker exec -it $${name} make -C /package

shell:
	docker exec -it $${name} /bin/bash

start:
	docker run -it --rm --name $${name} -w /problem \
		-v "$${PWD}:/problem" -v "$${PWD}/../../package:/package" \
		-p 6006:6006 -p 8888:8888 playground

.PHONY: all board setup shell start
endef
