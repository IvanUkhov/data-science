define data
name := $(1)
wnid := $(2)

imagenet_url := http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=$${wnid}

all: .renamed

list.txt:
	curl -L $${imagenet_url} -o $$@

.downloaded: list.txt
	mkdir -p images
	-cd images && \
		cat ../$$< | \
		sed $$$$'s/\r//' | \
		grep -i '\.\(jpg\|jpeg\)$$$$' | \
		grep -v \' | \
		xargs -n1 -P8 -t \
		curl --connect-timeout 10 --fail --silent -LO
	touch $$@

.cleaned: .downloaded
	cd images; \
	shopt -s nocaseglob; \
	for name in {*.jpg,*.jpeg}; do \
		if [[ ! $$$$(file -b "$$$${name}") =~ JPEG ]]; then \
			rm "$$$${name}"; \
		fi; \
	done
	touch $$@

.renamed: .cleaned
	cd images; \
	shopt -s nocaseglob; \
	for old in {*.jpg,*.jpeg}; do \
		new="$$$$(echo -n "$$$${old}" | shasum | cut -c1-20).jpg"; \
		echo "$$$${old} -> $$$${new}"; \
		mv "$$$${old}" "$$$${new}"; \
	done
	touch $$@

clean:
	rm -rf .downloaded .renamed images

.PHONY: all clean
endef
