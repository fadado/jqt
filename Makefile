# Utilities to manage site

OUTPUT=/tmp/jqt

.SILENT:

all: copy

copy:
	if [[ -d $(OUTPUT) ]]; then true; else echo 'Source directory does not exist!'; exit 1; fi
	if [[ ! -f $(OUTPUT)/Makefile ]]; then true; else echo 'Makefile will be overwriten!'; exit 1; fi
	rm -f *.html *.css README.md
	cp $(OUTPUT)/* .
	ls -lX

ci:
	git commit -a

push:
	git push origin gh-pages
