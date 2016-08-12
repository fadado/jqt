# jqt documentation site management

########################################################################
# Prerequisites
########################################################################

# We are using some of the newest GNU Make features... so require GNU
# Make version >= 3.82
version_test := $(filter 3.82,$(firstword $(sort $(MAKE_VERSION) 3.82)))
ifndef version_test
$(error GNU Make version $(MAKE_VERSION); version >= 3.82 is needed)
endif

########################################################################
# Configuration
########################################################################

# Disable builtins.
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

# Warn when an undefined variable is referenced.
MAKEFLAGS += --warn-undefined-variables

# Make will not print the recipe used to remake files.
.SILENT:

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

# Make will delete the target of a rule if it has changed and its recipe
# exits with a nonzero exit status.
.DELETE_ON_ERROR:

########################################################################
# Variables
########################################################################

# Global objects available in jq scripts:
#	.site		defined in the jqt call
#	.snippets	defined in the jqt call
#	.body		predefined by jqt
#	.front		predefined by jqt

# Some directories
CACHE=.jqt
DESTINATION = /tmp/jqt
CONTENT=./content
LAYOUTS=./layouts

# Commands
JQT = jqt \
      -I$(LAYOUTS) \
      -isite \
      -msite:$(CACHE)/site.json \
      -msnippets:$(CACHE)/snippets.json

MPCSS = gpp --nostdinc \
	+c '/*' '*/' \
	+c '//' '\n' \
	-U '&' ';' '(' ',' ');' '(' ')' '\$$' '' \
	-M '&' ';' '(' ',' ');' '(' ')'

HTMLMIN = sed '/^$$/d'
CSSMIN  = sed 's/^[ \t]\+//;s/[ \t]\$$//;/^$$/d;s/[\t ]*\([{}:,;>+~]\)[\t ]*/\1/g'

# Common sources for all targets
COMMON = \
	$(CACHE)/site.json \
	$(CACHE)/snippets.json \
	$(LAYOUTS)/default.html \
	$(LAYOUTS)/head.html \
	$(LAYOUTS)/footer.html \
	site.m \
	site.jq \

# Targets
TARGETS = \
	$(DESTINATION)/README.md	\
	$(DESTINATION)/document.html	\
	$(DESTINATION)/engine.html	\
	$(DESTINATION)/index.html	\
	$(DESTINATION)/metadata.html	\
	$(DESTINATION)/template.html	\
	$(DESTINATION)/jqt.css	\

########################################################################
# Rules
########################################################################

# Directories
$(CACHE) $(DESTINATION):
	mkdir $@ >/dev/null 2>&1 || true

# Assets
$(DESTINATION)/README.md: README.md | $(DESTINATION)
	cp $< $@

# Derived files
$(CACHE)/site.json: site.yaml | $(CACHE)
	yaml2json < $< > $@

$(CACHE)/snippets.pandoc: $(CONTENT)/snippets.yaml | $(CACHE)
	sed '/^\([a-zA-Z_-]\+\): *[>|]/{s/^\([a-zA-Z_-]\+\):.*/\1: >\n  $$\1$$/;b;};/^\([a-zA-Z_-]\+\): *[^#]/{s/^\([a-zA-Z_-]\+\):.*/\1: $$\1$$/;b;};d;' $< > $@

$(CACHE)/snippets.json: $(CONTENT)/snippets.yaml $(CACHE)/snippets.pandoc | $(CACHE)
	pandoc --from markdown --to html --template=$(CACHE)/snippets.pandoc $< | yaml2json > $@

# Pages
$(DESTINATION)/index.html: $(CONTENT)/home.md $(COMMON) | $(DESTINATION)
	$(JQT) -d $< $(LAYOUTS)/default.html | $(HTMLMIN) > $@

define Page
$(DESTINATION)/$(1).html: $(CONTENT)/$(1).md $(LAYOUTS)/page.html $$(COMMON) | $$(DESTINATION)
	$$(JQT) -d $$< $(LAYOUTS)/page.html | $$(HTMLMIN) > $$@
endef

$(eval $(call Page,engine))
$(eval $(call Page,document))
$(eval $(call Page,metadata))
$(eval $(call Page,template))

# CSS
$(DESTINATION)/jqt.css: style/jqt.css style/github.css
	$(MPCSS) $< | $(CSSMIN) > $@

# Main
all: $(TARGETS)
	@xmllint --noout --valid $(DESTINATION)/*.html

########################################################################
# Utilities
########################################################################

.PHONY: clean clobber build

clean:
	rm -rf $(DESTINATION)/*

clobber:
	rm -rf $(DESTINATION) $(CACHE)

build: clean all

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
