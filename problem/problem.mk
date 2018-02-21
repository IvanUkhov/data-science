define problem

export problem := $(1)
language := $(or $(2),$(2),python)
image := $(or $(3),$(3),playground-$${language})

all: start

shell:
	docker exec -it $${problem} /bin/bash

ifeq ($${language},python)
clean:
	docker exec -it $${problem} rm -rf /tmp/model

monitor:
	docker exec -it $${problem} tensorboard --logdir=/tmp/model

start:
	docker run -it --rm --name $${problem} \
		-v "$${PWD}:/problem" -w /problem \
		-p 6006:6006 -p 8888:8888 \
		$${image}

.PHONY: clean monitor
endif

ifeq ($${language},r)
start:
	docker run -it --rm --name $${problem} \
		-v "$${PWD}:/problem" -w /problem \
		-p 8888:8888 \
		$${image}
endif

.PHONY: all shell start

endef
