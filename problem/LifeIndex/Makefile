include ../problem.mk
$(eval $(call problem,lifeindex,r))

data:
	$(MAKE) -C $@

start: clean

clean:
	@rm -rf .Rhistory .rstudio

.PHONY: clean data
