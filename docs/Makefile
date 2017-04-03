# jqt documentation management

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
Destination := /tmp/jqt
Metadata    := .yummy

# Input files directories 
Assets  := ./assets
Blocks  := ./blocks
Content := ./content
Data    := ./data
Layouts := ./blocks
Styles  := ./styles

# Files to build or publish
Home 	:= index
Other	:= content data engine structure 
Static	:= styles.css

# Target filenames
ManPage := ../jqt.1.gz
HomePage   := $(Destination)/$(Home).html
OtherPages := $(foreach p,$(Other),$(Destination)/$(p).html)
Files	   := $(foreach f,$(Static),$(Destination)/$(f))
Pages  	   := $(HomePage) $(OtherPages)
Targets    := $(Pages) $(Files) $(ManPage)

########################################################################
# jqt command with options
########################################################################

# jqt with options
JQTFLAGS := \
	-5 					\
	-I./					\
	-iblocks/filters			\
	-msite:$(Metadata)/config.json		\
	-msnippets:$(Metadata)/snippets.json	\
	--toc-depth=4				\

JQT = jqt $(JQTFLAGS)

# gpp for the man page (to be build without calling jqt!)
GPP_MD_FLAGS := \
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
    
GPP_MD = gpp $(GPP_MD_FLAGS)

# hack to modify <detail> markup
DETAILS := sed					\
	-e 's/^<p><details><\/p>/<details>/'	\
	-e 's/^<p><\/details><\/p>/<\/details>/'\
	-e 's/^<p><summary>/<summary>/'		\
	-e 's/<\/summary><\/p>/<\/summary>/'

########################################################################
# Extra dependencies
########################################################################

$(Pages): \
	$(Blocks)/*/markup.html		\
	$(Blocks)/filters.jq		\
	$(Content)/LINKS.txt		\
	$(Content)/macros.m		\
	$(Metadata)/config.json		\
	$(Metadata)/snippets.json	\


$(OtherPages):			\
	$(Content)/FLOW.txt	\
	$(Layouts)/page.html	\
	$(Content)/opt/*.txt	\

$(HomePage) 			\
$(Destination)/structure.html:	\
	$(Content)/EXAMPLE.txt	\

$(Destination)/styles.css:		\
	$(Blocks)/*/*style.css		\
	$(Styles)/*.css			\
	$(Styles)/*.m 			\
	$(Styles)/milligram/*.css	\

########################################################################
# Rules
########################################################################

all: $(Targets) cp_assets

# Directories
$(Metadata)	\
$(Destination):
	mkdir $@ >/dev/null 2>&1 || true

# Metadata files
$(Metadata)/config.json: config.yaml \
| $(Metadata)
	yaml2json <$< >$@

$(Metadata)/snippets.json: $(Content)/snippets.yaml \
| $(Metadata)
	jqt -T <$< | yaml2json > $@

# Assets
cp_assets: | $(Destination)
	cp --verbose --recursive --update $(Assets)/* $(Destination)

# HTML pages
define Target
$(Destination)/$(1).html: $(Content)/$(1).md $(Layouts)/$(2).html \
| $(Destination)
	$$(info ==> $$@)
	$(JQT) -d $$< $(Layouts)/$(2).html | $(DETAILS) > $$@
endef

$(eval $(call Target,$(Home),page))
$(foreach p,$(Other),$(eval $(call Target,$(p),page-toc)))

# CSS stylesheet
$(Destination)/styles.css: $(Styles)/page.css
	$(info ==> $@)
	jqt -P CSS-min -I$(Styles) <$< >$@

# Man page: jqt(1)
$(ManPage): $(Content)/jqt.1.markdown
	$(info ==> $@)
	$(GPP_MD) -I$(Content) <$<			\
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

clobber: clean
	rm -rf $(Destination) $(Metadata)

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

# Validation with vnu.jar
VNU := /usr/local/vnu/vnu.jar
valid: all
	xmlwf $(Destination)/*.html
	java -jar $(VNU) --errors-only --format gnu $(Destination)/*.html

lint: all
	xmlwf $(Destination)/*.html
	java -jar $(VNU) --format text $(Destination)/*.html

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
