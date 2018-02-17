name := playground-tensorflow

image:
	docker rmi ${name} || true
	docker build -t ${name} .

.PHONY: image
