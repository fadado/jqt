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
Meta := .yummy
Destination := /tmp/jqt

# Directories for input files
Assets := ./assets
Content := ./content
Styles := ./styles
Layouts := ./layouts

# Common sources for all targets
Common := \
	$(Meta)/config.json		\
	$(Meta)/snippets.json		\
	$(Layouts)/default.html		\
	$(Layouts)/head.html		\
	$(Layouts)/footer.html		\
	$(Content)/LINKS.txt		\
	filters.jq			\
	macros.m			\

# Files to "build"
Home := index
Pages := content data engine structure 
Files := README.md jqt.css
ManPage := ../jqt.1.gz
Targets := \
	$(foreach f,$(Files),$(Destination)/$(f))		\
	$(foreach p,$(Home) $(Pages),$(Destination)/$(p).html)	\
	$(ManPage)						\

########################################################################
# Commands
########################################################################

# The template engine (.site and .snippets defined in the jqt call)
JQT = jqt $(JQTFLAGS)
JQTFLAGS := \
	-I$(Layouts)				\
	-I$(Content)				\
	-ifilters				\
	-msite:$(Meta)/config.json		\
	-msnippets:$(Meta)/snippets.json	\
	--toc-depth=4				\

# Validate output pages (disable or redefine as you like)
XHTMLValid := test -f /etc/xml/xhtml1-dtds.xml			 \
		&& xmllint --noout --valid $(Destination)/*.html \
		&& echo 'XHTML valid!'
# Uncomment to disable XML validation
#XHTMLValid := :

########################################################################
# Rules
########################################################################

# Main
all: $(Targets)
	$(XHTMLValid)

# Directories
$(Meta) $(Destination): ; mkdir $@ >/dev/null 2>&1 || true

# Metad files
$(Meta)/config.json: config.yaml \
| $(Meta)
	yaml2json <$< >$@

$(Meta)/snippets.json: $(Content)/snippets.yaml \
| $(Meta)
	jqt -T <$< | yaml2json > $@

# Target files
$(Destination)/README.md: $(Assets)/README.md \
| $(Destination)
	$(info ==> $@)
	cp $< $@

$(Destination)/index.html: $(Content)/home.md $(Common) \
| $(Destination)
	$(info ==> $@)
	$(JQT) -d $< $(Layouts)/default.html > $@

$(foreach p,$(Pages),$(Destination)/$(p).html): $(Content)/FLOW.txt $(Content)/opt/*.txt
$(Destination)/index.html $(Destination)/structure.html: $(Content)/EXAMPLE.txt

define Target
$(Destination)/$(1).html: $(Content)/$(1).md $(Layouts)/$(2).html $(Common) \
| $(Destination)
	$$(info ==> $$@)
	$(JQT) -d $$< $(Layouts)/$(2).html > $$@
endef

$(foreach p,$(Pages),$(eval $(call Target,$(p),page)))

$(Destination)/jqt.css: $(Styles)/jqt.css $(Styles)/github.css
	$(info ==> $@)
	jqt -P CSS-min -I$(Styles) <$< >$@

# Man page (to be build without callig `jqt`!)
GPP_MD := \
	-U '<%' '>' '\B' '\B' '\W>' '<' '>' '$$' ''	\
	-M '<%' '>' '\B' '\B' '\W>' '<' '>'		\
	+sccc '&\n' '' ''				\
	+sccc '\\n' '' ''				\
	+sccc '<\#' '\#>\n' ''				\
	+siqi "'" "'" '\'				\
	+siQi '"' '"' '\'				\
	+ssss '<!--' '-->' ''				\
	+ssss '`'  '`' ''				\
	+ssss '\n```' '\n```' ''			\
	+ssss '\n~~~' '\n~~~' ''			\
    
$(ManPage): $(Content)/jqt.1.markdown
	$(info ==> $@)
	gpp $(GPP_MD) -I$(Content) <$<			\
	| pandoc --standalone --from markdown --to man	\
	| gzip > $@

# Help text
/tmp/help: $(Content)/help.markdown
	jqt -P MarkDown -I$(Content) <$<				\
	| pandoc --from markdown --to plain -				\
	| sed '1,7b;/^$$/d;s/_\([A-Z]\+\)_/\1/g;/^[^A-Z]/s/^/    /'	\
	> $@

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
