define problem
name := $(1)

all: start

board:
	docker exec -it $${name} tensorboard --logdir=/tmp/model

clean:
	docker exec -it $${name} rm -rf /tmp/model

shell:
	docker exec -it $${name} /bin/bash

start:
	docker run -it --rm --name $${name} -w /problem \
		-v "$${PWD}:/problem" -p 6006:6006 -p 8888:8888 playground

.PHONY: all board clean shell start
endef
