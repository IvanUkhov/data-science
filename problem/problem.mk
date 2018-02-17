define problem
name := $(1)
image := $(or $(2),$(2),tensorflow)

all: start

board:
	if [[ $${image} == tensorflow ]]; then \
		docker exec -it $${name} tensorboard --logdir=/tmp/model; \
	else \
		docker exec -it $${name} th -ldisplay.start 6006 0.0.0.0; \
	fi

clean:
	docker exec -it $${name} rm -rf /tmp/model

shell:
	docker exec -it $${name} /bin/bash

start:
	docker run -it --rm --name $${name} -w /problem \
		-v "$${PWD}:/problem" -p 6006:6006 -p 8888:8888 playground-$${image}

.PHONY: all board clean shell start
endef
