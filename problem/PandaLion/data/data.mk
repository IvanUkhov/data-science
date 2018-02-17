define data
name := $(1)
wnid := $(2)

imagenet_url := http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=$${wnid}

images: list.txt
	mkdir -p $$@
	-cd $$@ && \
		cat ../$$< | \
		grep -v \' | \
		grep -v '^$$$$' | \
		sed $$$$'s/\r//' | \
		xargs -n1 -P8 -t \
		curl --silent --connect-timeout 10 -LO

list.txt:
	curl -L $${imagenet_url} -o $$@

clean:
	rm -rf images

.PHONY: clean
endef
