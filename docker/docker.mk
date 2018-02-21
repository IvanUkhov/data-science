define docker

name := playground-$(1)

image:
	docker rmi $${name} || true
	docker build -t $${name} .

.PHONY: image

endef
