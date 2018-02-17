define data
name := $(1)
wnid := $(2)

imagenet_url := http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=$${wnid}

list.txt:
	curl -L $${imagenet_url} -o $$@
endef
