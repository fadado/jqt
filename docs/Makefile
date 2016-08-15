# jqt site documentation management

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

# Output directories
CACHE := .jqt
DESTINATION := /tmp/jqt

# Directories for input files
CONTENT := ./content
STRUCTURE := ./structure
PRESENTATION := ./presentation

# The template engine (.site and .snippets defined in the jqt call)
JQT := jqt \
	-I$(STRUCTURE) \
	-I$(CONTENT) \
	-ifilters \
	-msite:$(CACHE)/site.json \
	-msnippets:$(CACHE)/snippets.json \
	--toc-depth=3 \

# Macro process CSS
MPCSS := gpp --nostdinc \
	+c '/*' '*/' \
	+c '//' '\n' \
	-U '&' ';' '(' ',' ');' '(' ')' '\$$' '' \
	-M '&' ';' '(' ',' ');' '(' ')' \

# Minify CSS
CSSMIN  := sed 's/^[ \t]\+//;s/[ \t]\$$//;/^$$/d;s/[\t ]*\([{}:,;>+~]\)[\t ]*/\1/g'

# Common sources for all targets
COMMON := \
	$(CACHE)/site.json \
	$(CACHE)/snippets.json \
	$(STRUCTURE)/default.html \
	$(STRUCTURE)/head.html \
	$(STRUCTURE)/footer.html \
	$(CONTENT)/LINKS.md \
	filters.jq \
	macros.m \

# Files to "build"
ASSETS := README.md jqt.css
PAGES := engine document metadata template
TARGETS := $(foreach f,$(ASSETS) $(foreach p,index $(PAGES),$(p).html),$(DESTINATION)/$(f))

########################################################################
# Rules
########################################################################

# Main
all: $(TARGETS)
	test -f /etc/xml/xhtml1-dtds.xml \
	&& xmllint --noout --valid $(DESTINATION)/*.html \
	&& echo 'XHTML valid!'

# Directories
$(CACHE) $(DESTINATION):
	mkdir $@ >/dev/null 2>&1 || true

# Cached files
$(CACHE)/site.json: site.yaml \
| $(CACHE)
	yaml2json < $< > $@

$(CACHE)/snippets.pandoc: private id=^\([a-zA-Z_-]\+\)
$(CACHE)/snippets.pandoc: $(CONTENT)/snippets.yaml \
| $(CACHE)
	sed '/$(id): *[>|]/{s/$(id):.*/\1: >\n  $$\1$$/;b;};/$(id): *[^#]/{s/$(id):.*/\1: $$\1$$/;b;};d;' \
	< $< > $@

$(CACHE)/snippets.json: $(CONTENT)/snippets.yaml $(CACHE)/snippets.pandoc \
| $(CACHE)
	pandoc --from markdown --to html --template=$(CACHE)/snippets.pandoc $< \
	| yaml2json > $@

# Target files
$(DESTINATION)/README.md: README.md \
| $(DESTINATION)
	$(info ==> $@)
	cp $< $@

$(DESTINATION)/index.html: $(CONTENT)/home.md $(COMMON) \
| $(DESTINATION)
	$(info ==> $@)
	$(JQT) -d $< $(STRUCTURE)/default.html > $@

$(DESTINATION)/engine.html: $(CONTENT)/FLOW.md
$(DESTINATION)/index.html: $(CONTENT)/EXAMPLE.md
$(DESTINATION)/template.html: $(CONTENT)/EXAMPLE.md

define Target
$(DESTINATION)/$(1).html: $(CONTENT)/$(1).md $(STRUCTURE)/$(2).html $(COMMON) \
| $(DESTINATION)
	$$(info ==> $$@)
	$$(JQT) -d $$< $(STRUCTURE)/$(2).html > $$@
endef

$(foreach p,$(PAGES),$(eval $(call Target,$(p),page)))

$(DESTINATION)/jqt.css: $(PRESENTATION)/jqt.css $(PRESENTATION)/github.css
	$(info ==> $@)
	$(MPCSS) $< | $(CSSMIN) > $@

########################################################################
# Utilities
########################################################################

.PHONY: clean clobber build

clean:
	rm -rf $(DESTINATION)/*

clobber:
	rm -rf $(DESTINATION) $(CACHE)

build: clean all

# Show targets
.PHONY: help
help:
	echo 'Targets:';					\
	$(MAKE) --print-data-base --just-print 2>&1		\
	| grep -v '^[mM]akefile'				\
	| awk '/^[^ \t.%][-A-Za-z0-9_]*:/ { print $$1 }'	\
	| sort --unique						\
	| sed 's/:\+$$//'					\
	| pr --omit-pagination --indent=4 --width=80 --columns=4

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
