# jqt docs management
#

########################################################################
# Configuration
########################################################################

# Disable builtins.
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

# Warn when an undefined variable is referenced.
MAKEFLAGS += --warn-undefined-variables

# Make will not print the recipe used to remake files.
#.SILENT:

# Eliminate use of the built-in implicit rules. Also clear out the
# default list of suffixes for suffix rules.
.SUFFIXES:

# Sets the default goal to be used if no targets were specified on the
# command line.
.DEFAULT_GOAL := all

.PHONY: all

# Default shell: if we require GNU Make, why not require Bash?
SHELL := /bin/bash

# The argument(s) passed to the shell are taken from the variable
# .SHELLFLAGS.
.SHELLFLAGS := -o errexit -o pipefail -o nounset -c

########################################################################
# Variables
########################################################################

OUTPUT = /tmp/jqt

JQT = jqt -ifilters -Mconfig:config.yaml -msnippets:snippets.json
HTMLMIN = sed '/^$$/d' 

TEMPLATES = main.html head.html footer.html
COMMON = $(TEMPLATES) config.yaml snippets.json filters.jq
ASSETS = github.css jqt.css README.md

TARGETS = \
	$(OUTPUT)/document.html	\
	$(OUTPUT)/engine.html	\
	$(OUTPUT)/index.html	\
	$(OUTPUT)/metadata.html	\
	$(OUTPUT)/template.html	\

########################################################################
# Rules
########################################################################

all: $(TARGETS)
	cp -uv $(ASSETS) $(OUTPUT)
	xmllint --noout --valid $(OUTPUT)/*.html

snippets.pandoc: snippets.md
	sed -n 's/^\([a-zA-Z_-]\+\): *[^#].*/\1: >\n  $$\1$$/p' $< > $@

snippets.json: snippets.md snippets.pandoc
	pandoc --from markdown --to html --template=snippets.pandoc $< | yaml2json > $@

$(OUTPUT):
	mkdir $(OUTPUT) >/dev/null 2>&1 || true

$(OUTPUT)/index.html: home.md index.html $(COMMON) | $(OUTPUT)
	$(JQT) -DBODY_BLOCK=index.html -d $< main.html | $(HTMLMIN) > $@ 

define Page
$(OUTPUT)/$(1).html: $(1).md page.html $$(COMMON) | $$(OUTPUT)
	$$(JQT) -DBODY_BLOCK=page.html -d $$< main.html | $$(HTMLMIN) > $$@ 
endef

$(eval $(call Page,engine))
$(eval $(call Page,document))
$(eval $(call Page,metadata))
$(eval $(call Page,template))

########################################################################
# Utilities
########################################################################

.PHONY: clean clobber build

clean:
	rm -f $(OUTPUT)/* snippets.json snippets.pandoc

clobber: clean
	rmdir $(OUTPUT) >/dev/null 2>&1 || true

build: clean all

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
