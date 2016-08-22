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
.PHONY: all
.DEFAULT_GOAL := all

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
Meta := .jqt
Destination := /tmp/jqt

# Directories for input files
Assets := ./assets
Content := ./content
Presentation := ./presentation
Structure := ./structure

# Common sources for all targets
Common := \
	$(Meta)/config.json \
	$(Meta)/snippets.json \
	$(Structure)/default.html \
	$(Structure)/head.html \
	$(Structure)/footer.html \
	$(Content)/LINKS.md \
	filters.jq \
	macros.m \

# Files to "build"
Home := index
Pages := engine document metadata template
Files := README.md jqt.css
ManPage := ../jqt.1.gz
Targets := \
	$(ManPage) \
	$(foreach f,$(Files),$(Destination)/$(f)) \
	$(foreach f,$(foreach p,$(Home) $(Pages),$(p).html),$(Destination)/$(f))

########################################################################
# Commands
########################################################################

# The template engine (.site and .snippets defined in the jqt call)
JQT = jqt $(JQTFLAGS)
JQTFLAGS := \
	-I$(Structure) \
	-I$(Content) \
	-ifilters \
	-msite:$(Meta)/config.json \
	-msnippets:$(Meta)/snippets.json \
	--toc-depth=4 \

# Macro process MarkDown
MPMD := gpp --nostdinc \
	+sccc '&\n' '' '' \
	+sccc '<\#' '\#>\n' '' \
	+siqi "'" "'" '' \
	+siQi '"' '"' '' \
	+ssss '<!--' '-->' '' \
	+ssss '`' '`' '' \
	+ssss '\n```' '\n```' '' \
	+ssss '\n~~~' '\n~~~' '' \
	-U '<%' '>' '\B' '\B' '\W>' '<' '>' '$$' '' \
	-M '<%' '>' '\B' '\B' '\W>' '<' '>' \

# Macro process JSON
MPJSON := gpp --nostdinc \
        +cccc '\\n' '' \
        +cccc '/*' '*/' \
        +cccc '//' '\n' \
        +sSSS '"' '"' '\' \
	-U '&' ';' '(' ',' ');' '(' ')' '$$' '' ) \
	-M '<!' '>' '\b' '\b' '>' '<' '>' )

# Macro process CSS
MPCSS := gpp --nostdinc \
	+c '/*' '*/' \
	+c '//' '\n' \
	-U '&' ';' '(' ',' ')' '(' ')' '\$$' '' \
	-M '&' ';' '(' '\b' ')' '(' ')' \

# Minify CSS
CSSMIN := sed 's/^[ \t]\+//;s/[ \t]\$$//;/^$$/d;s/[\t ]*\([{}:,;>+~]\)[\t ]*/\1/g'

# Validate output pages (disable or redefine as you like)
XHTMLValid := test -f /etc/xml/xhtml1-dtds.xml \
		&& xmllint --noout --valid $(Destination)/*.html \
		&& echo 'XHTML valid!'
#XHTMLValid := :

########################################################################
# Rules
########################################################################

# Main
all: $(Targets)
	$(XHTMLValid)

# Directories
$(Meta) $(Destination):
	mkdir $@ >/dev/null 2>&1 || true

# Metad files
$(Meta)/config.json: config.yaml \
| $(Meta)
	yaml2json < $< > $@

$(Meta)/snippets.pandoc: private id=^\([a-zA-Z_-]\+\)
$(Meta)/snippets.pandoc: $(Content)/snippets.yaml \
| $(Meta)
	sed '/$(id): *[>|]/{s/$(id):.*/\1: >\n  $$\1$$/;b;};/$(id): *[^#]/{s/$(id):.*/\1: $$\1$$/;b;};d;' \
	< $< > $@

$(Meta)/snippets.json: $(Content)/snippets.yaml $(Meta)/snippets.pandoc \
| $(Meta)
	pandoc --from markdown --to html --template=$(Meta)/snippets.pandoc $< \
	| yaml2json > $@

# Target files
$(Destination)/README.md: $(Assets)/README.md \
| $(Destination)
	$(info ==> $@)
	cp $< $@

$(Destination)/index.html: $(Content)/home.md $(Common) \
| $(Destination)
	$(info ==> $@)
	$(JQT) -d $< $(Structure)/default.html > $@

$(Destination)/engine.html: $(Content)/FLOW.md
$(Destination)/index.html: $(Content)/EXAMPLE.md
$(Destination)/template.html: $(Content)/EXAMPLE.md

define Target
$(Destination)/$(1).html: $(Content)/$(1).md $(Structure)/$(2).html $(Common) \
| $(Destination)
	$$(info ==> $$@)
	$(JQT) -d $$< $(Structure)/$(2).html > $$@
endef

$(foreach p,$(Pages),$(eval $(call Target,$(p),page)))

$(Destination)/jqt.css: $(Presentation)/jqt.css $(Presentation)/github.css
	$(info ==> $@)
	$(MPCSS) $< | $(CSSMIN) > $@

# Help text
/tmp/help: $(Content)/help.txt
	$(MPMD) -I. -I$(Content) $<  \
	| pandoc --from markdown --to plain - \
	| sed '1,7b;/^$$/d;s/_\([A-Z]\+\)_/\1/g;/^[^A-Z]/s/^/    /' \
	> $@

# Man page
$(ManPage): $(Content)/jqt.1.md
	$(MPMD) -I. -I$(Content) $<  \
	| pandoc --standalone --from markdown --to man \
	| gzip > $@

########################################################################
# Utilities
########################################################################

.PHONY: clean clobber build

clean:
	rm -rf $(Destination)/* $(ManPage)

clobber:
	rm -rf $(Destination) $(Meta)

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
