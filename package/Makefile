packages := book facets

destination := $(shell python -c 'import site; print(site.getsitepackages()[0])')

install: $(patsubst %,${destination}/%/__init__.py,${packages})
	jupyter nbextension install facets/source/facets-dist

${destination}/%/__init__.py:
	ln -s "$(shell pwd)/$*" "${destination}/$*"

.PHONY: install
