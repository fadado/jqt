# Utilities to manage site

OUTPUT=/tmp/jqt

.SILENT:

.PHONY: all reset copy ci push

all: copy

reset:
	git clean -fd

copy: reset
	if [[ -d $(OUTPUT) ]]; then true; else echo 'Source directory does not exist!'; exit 1; fi
	if [[ ! -f $(OUTPUT)/Makefile ]]; then true; else echo 'Makefile will be overwriten!'; exit 1; fi
	rm -f *.html *.css README.md
	cp $(OUTPUT)/* .
	ls -lX

ci:
	git add .
	git commit

push:
	git push origin gh-pages
