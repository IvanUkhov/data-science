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
	for name in *.{jpg,jpeg}; do \
		if [[ ! $$$$(file -b "$$$${name}") =~ JPEG ]]; then \
			rm "$$$${name}"; \
		fi; \
	done
	touch $$@

.renamed: .cleaned
	cd images; \
	number=1; \
	shopt -s nocaseglob; \
	for old in *.{jpg,jpeg}; do \
		new=$$$$(printf "%04d.jpg" "$$$${number}"); \
		mv "$$$${old}" "$$$${new}"; \
		let number=number+1; \
	done
	touch $$@

clean:
	rm -rf .downloaded .renamed images

.PHONY: all clean
endef
