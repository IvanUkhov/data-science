name := playground-python

image:
	docker rmi ${name} || true
	docker build -t ${name} .

.PHONY: image
