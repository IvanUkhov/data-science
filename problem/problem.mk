define problem

export problem := $(1)
language := $(or $(2),$(2),python)
image := $(or $(3),$(3),$${language})

ifneq ($${image},)
all: start

shell:
	docker exec -it $${problem} /bin/bash

.PHONY: all shell
endif

ifeq ($${image},python)
start:
	@echo "Address: \033[0;32mhttp://localhost:8888\033[0m"
	@echo
	docker run -it --rm \
		--name $${problem} \
		--publish 6006:6006 \
		--publish 8888:8888 \
		--volume "$${PWD}:/home/jupyter" \
		--workdir /home/jupyter \
		data-science-$${image}

.PHONY: start
endif

ifeq ($${image},rnotebook)
start:
	@echo "Address: \033[0;32mhttp://localhost:8888\033[0m"
	@echo
	docker run -it --rm \
		--name $${problem} \
		--publish 8888:8888 \
		--volume "$${PWD}:/home/jupyter" \
		--workdir /home/jupyter \
		data-science-$${image}

.PHONY: start
endif

ifeq ($${image},rstudio)
start:
	@echo "Address:  \033[0;32mhttp://localhost:8787\033[0m"
	@echo "User:     \033[0;32mrstudio\033[0m"
	@echo "Password: \033[0;32mpassword\033[0m"
	@echo
	docker run -it --rm \
		--env PASSWORD=password \
		--name $${problem} \
		--publish 8787:8787 \
		--volume "$${PWD}:/home/rstudio" \
		--workdier /home/rstudio \
		data-science-$${image}

.PHONY: start
endif

ifeq ($${language},python)
tensorboard-kill:
	kill -9 $$$$(ps -ef | grep bin/tensorboard | head -1 | tr -s ' ' | cut -d ' ' -f2)

tensorboard-start:
	tensorboard --logdir=output

.PHONY: tensorboard-kill tensorboard-start
endif

endef
