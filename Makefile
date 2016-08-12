# Utilities to manage site

.SILENT:

DESTINATION=/tmp/jqt

.PHONY: all reset copy ci push

all: copy

reset:
	git clean -fd

copy: reset
	if [[ -d $(DESTINATION) ]]; then true; else echo 'Source directory does not exist!'; exit 1; fi
	if [[ ! -f $(DESTINATION)/Makefile ]]; then true; else echo 'Makefile will be overwriten!'; exit 1; fi
	rm -f *.html *.css README.md
	cp $(DESTINATION)/* .
	ls -lX

ci:
	git add .
	git commit

push:
	git push origin gh-pages
