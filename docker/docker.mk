define docker

name := data-science-$(1)

image:
	docker rmi $${name} || true
	docker build -t $${name} .

.PHONY: image

endef
