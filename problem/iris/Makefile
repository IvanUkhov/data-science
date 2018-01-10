name := iris

start:
	docker run -it --rm --name ${name} -v ${PWD}:/work -w /work \
		-p 6006:6006 -p 8888:8888 tensorflow/tensorflow:latest-py3

shell:
	docker exec -it ${name} /bin/bash

.PHONY: start shell
