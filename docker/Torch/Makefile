name := playground-torch

image:
	docker rmi ${name} || true
	docker build -t ${name} .

.PHONY: image
