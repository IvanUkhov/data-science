define problem

export problem := $(1)
language := $(or $(2),$(2),python)
image := $(or $(3),$(3),$${language})

all: start

shell:
	docker exec -it $${problem} /bin/bash

ifeq ($${image},python)
clean:
	docker exec -it $${problem} rm -rf /tmp/model

monitor:
	docker exec -it $${problem} tensorboard --logdir=/tmp/model

start:
	@echo "Jupyter: \033[0;32mhttp://localhost:8888\033[0m"
	@echo "TensorBoard: \033[0;32mhttp://localhost:6006\033[0m"
	@echo
	docker run -it --rm --name $${problem} \
		-v "$${PWD}:/home/jupyter" -w /home/jupyter \
		-p 6006:6006 -p 8888:8888 \
		playground-$${image}

.PHONY: clean monitor
endif

ifeq ($${image},rnotebook)
start:
	@echo "Jupyter: \033[0;32mhttp://localhost:8888\033[0m"
	@echo
	docker run -it --rm --name $${problem} \
		-v "$${PWD}:/home/jupyter" -w /home/jupyter \
		-p 8888:8888 \
		playground-$${image}
endif

ifeq ($${image},rstudio)
start:
	@echo "RStudio: \033[0;32mhttp://localhost:8787\033[0m"
	@echo
	docker run -it --rm --name $${problem} \
		-e PASSWORD=password \
		-v "$${PWD}:/home/rstudio" -w /home/rstudio \
		-p 8787:8787 \
		playground-$${image}
endif

.PHONY: all shell start

endef
