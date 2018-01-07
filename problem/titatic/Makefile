name := titanic

start:
	docker run -it --rm --name ${name} -v ${PWD}:/work -w /work \
		-p 8888:8888 jupyter/all-spark-notebook

shell:
	docker exec -it ${name} /bin/bash

.PHONY: start shell
