define data
name := $(1)
wnid := $(2)

list_url := http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=$${wnid}

all: .done

clean:
	rm -rf images .done*

list.txt:
	curl -L $${list_url} -o $$@

.done_download: list.txt
	mkdir -p images
	-cd images && \
		cat ../$$< | \
		sed $$$$'s/\r//' | \
		grep -i '\.\(jpg\|jpeg\)$$$$' | \
		grep -v \' | \
		xargs -n1 -P8 -t \
		curl --connect-timeout 10 --fail --silent -LO
	touch $$@

.done_clean: .done_download
	cd images; \
	shopt -s nocaseglob; \
	for name in {*.jpg,*.jpeg}; do \
		if [[ ! $$$$(file -b "$$$${name}") =~ JPEG ]]; then \
			rm "$$$${name}"; \
		fi; \
	done
	touch $$@

.done_rename: .done_clean
	cd images; \
	shopt -s nocaseglob; \
	for old in {*.jpg,*.jpeg}; do \
		new="$$$$(echo -n "$$$${old}" | shasum | cut -c1-20).jpg"; \
		mv "$$$${old}" "$$$${new}"; \
	done
	touch $$@

.done_split: .done_rename
	mkdir -p images/train;
	mkdir -p images/test;
	list=($$$$(find images -name *.jpg)); \
	count=$$$${#list[@]}; \
	train=$$$$(($$$${count} * 80 / 100)); \
	test=$$$$(($$$${count} - $$$${train})); \
	for name in $$$${list[@]:0:$$$${train}}; do \
		mv "$$$${name}" images/train; \
	done; \
	for name in $$$${list[@]:$$$${train}:$$$${test}}; do \
		mv "$$$${name}" images/test; \
	done
	touch $$@

.done: .done_split
	touch $$@

.PHONY: all clean
endef
