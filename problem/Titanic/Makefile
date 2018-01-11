name := titanic

start:
	docker run -it --rm --name ${name} -v ${PWD}:/work -w /work \
		-p 8888:8888 jupyter/datascience-notebook

shell:
	docker exec -it ${name} /bin/bash

.PHONY: start shell
