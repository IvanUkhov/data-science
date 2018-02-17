all:
	$(MAKE) -C lion
	$(MAKE) -C panda
	ln -sF lion/images/train trainA
	ln -sF lion/images/test testA
	ln -sF panda/images/train trainB
	ln -sF panda/images/test testB

.PHONY: all
