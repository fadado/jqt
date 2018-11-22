########################################################################
# jqt management
########################################################################

# Parameters:
# 	prefix
# 	bindir
# 	datadir
# 	mandir

PROJECT := jqt

prefix	?= /usr/local
bindir	?= $(prefix)/bin
datadir	?= $(prefix)/share
mandir	?= $(prefix)/share/man

########################################################################
# Prerequisites
########################################################################

# We are using some of the newest GNU Make features... so require GNU
# Make version >= 3.82
version_test := $(filter 3.82,$(firstword $(sort $(MAKE_VERSION) 3.82)))
ifndef version_test
$(error GNU Make version $(MAKE_VERSION); version >= 3.82 is needed)
endif

ifeq (,$(filter install uninstall,$(MAKECMDGOALS)))
ifeq (0,$(shell id --user))
$(error Root only can make "(un)install" targets)
endif
else
ifneq (0,$(shell id --user))
$(error Only root can make "(un)install" targets)
endif
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

# When it is time to consider phony targets, make will run its recipe
# unconditionally, regardless of whether a file with that name exists or
# what its last-modification time is.
.PHONY: all clean

# Default shell: if we require GNU Make, why not require Bash?
SHELL := /bin/bash

# Argument(s) passed to the shell.
.SHELLFLAGS := -o errexit -o pipefail -o nounset -c

# Make will delete the target of a rule if it has changed and its recipe
# exits with a nonzero exit status.
.DELETE_ON_ERROR:

########################################################################
# Targets and variables
########################################################################

# The only "productive" target...
ManPage := jqt.1.gz

# Dependencies from documentations files
DOCS := docs
CONTENT := $(DOCS)/content

########################################################################
# Install `jqt` dependencies.
#
# Warning: only with `dnf`!
# Modify this rule as a template to your own script.
########################################################################

.PHONY: setup

setup:
	@rpm -q --quiet general-purpose-preprocessor || sudo dnf -y install general-purpose-preprocessor
	@test -e /usr/bin/jq || test -e /usr/local/bin/jq || sudo dnf -y install jq
	@rpm -q --quiet pandoc || sudo dnf -y install pandoc
	@rpm -q --quiet python2-pyyaml || sudo dnf -y install python2-pyyaml
	@echo Done!

########################################################################
# Install scripts and data
########################################################################

.PHONY: install uninstall

install: all
	install --directory $(bindir) $(datadir) $(mandir)/man1 $(datadir)/$(PROJECT)/{sake.d,milligram}
	install --verbose --compare --mode 555 bin/* $(bindir)
	install --verbose --compare --mode 644 share/*.m $(datadir)/$(PROJECT)
	install --verbose --compare --mode 644 $(ManPage) $(mandir)/man1
	install --verbose --compare --mode 644 share/sake.d/*.* $(datadir)/$(PROJECT)/sake.d
	install --verbose --compare --mode 644 share/milligram/*.* $(datadir)/$(PROJECT)/milligram
	sed -i -e "s#DATADIR='.*'#DATADIR='$(datadir)'#" $(bindir)/jqt
	sed -i -e "s#DATADIR='.*'#DATADIR='$(datadir)'#" $(bindir)/sake

uninstall:
	rm --verbose --force -- $(addprefix $(prefix)/,$(wildcard bin/*))
	rm --verbose --force -- $(mandir)/man1/$(ManPage)
	test -d $(datadir)/$(PROJECT)				  \
	&& rm --verbose --force --recursive $(datadir)/$(PROJECT) \
	|| true

########################################################################
# Show targets
########################################################################

.PHONY: list

list:
	echo 'Usage: make TARGET [parameter=value...]'
	echo 'Targets:';					\
	$(MAKE) --print-data-base --just-print 2>&1		\
	| grep -v '^[mM]akefile'				\
	| awk '/^[^ \t.%][-A-Za-z0-9_]*:/ { print $$1 }'	\
	| sort --unique						\
	| sed 's/:\+$$//'					\
	| pr --omit-pagination --indent=4 --width=80 --columns=4
	echo 'Default parameters:';				\
	echo '    prefix    = $(prefix)';			\
	echo '    bindir    = $(bindir)';			\
	echo '    datadir   = $(datadir)';			\
	echo '    mandir    = $(mandir)'

########################################################################
# Generate help text
########################################################################

# Independent target: helps generating text for `jqt -h`
# Needs explicit call: `make /tmp/help`
/tmp/help: $(CONTENT)/help.text
	$(info ==> $@)
	jqt -P MarkDown -I$(DOCS) < $<					\
	| pandoc --from markdown --to plain -				\
	| sed '1,7b;/^$$/d;s/_\([A-Z]\+\)_/\1/g;/^[^A-Z]/s/^/    /'	\
	> $@

clean:: ; @rm -f /tmp/help

########################################################################
# Generate man page for jqt
########################################################################

# gpp for the man page (to be build without calling jqt!)
GPP_MD := gpp						\
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
    
# Man page: jqt(1)
$(ManPage): $(CONTENT)/jqt.1.text
	$(info ==> $@)
	@$(GPP_MD) -I$(DOCS) < $<			\
	| pandoc --standalone --from markdown --to man	\
	| gzip > $@

# Default target
all: $(ManPage)

# Add prerequisites and recipes to common targets
clean:: ; @rm -f $(ManPage)

########################################################################
# Tests
########################################################################

.PHONY: check

check: test-jqt test-expand test-format

clean:: ; rm -f tests/*/generated/*

#
# Test JQT
#
.PHONY: test-jqt test-cond test-expr test-loop test-macros test-syntax

test-jqt: test-cond test-expr test-loop test-macros test-syntax

define TestJQT
# Run one example
test-$(1)-%.jqt:
	echo "==> jqt: $$(subst test-,,$$(basename $$@))"
	if test -e tests/jqt/$$(subst test-,,$$(basename $$@)).json; then \
	    jqt -ifilters -Ltests/jqt/filters -Mtop:tests/jqt/$$(subst test-,,$$(basename $$@)).json -w tests/jqt/$$(subst test-,,$$@) tests/jqt/generated/$$(subst test-,,$$(basename $$@)).txt; \
	else \
	    jqt -ifilters -Ltests/jqt/filters -w tests/jqt/$$(subst test-,,$$@) tests/jqt/generated/$$(subst test-,,$$(basename $$@)).txt; \
	fi
	diff tests/jqt/expected/$$(subst test-,,$$(basename $$@)).txt tests/jqt/generated/$$(subst test-,,$$(basename $$@)).txt
# Run one example named without file suffix
test-$(1)-%: test-$(1)-%.jqt ;
# Run all tests
test-$(1): $(sort $(subst tests/jqt/,test-,$(wildcard tests/jqt/$(1)-[0-9][0-9].jqt)))
endef

$(eval $(call TestJQT,cond))
$(eval $(call TestJQT,expr))
$(eval $(call TestJQT,loop))
$(eval $(call TestJQT,macros))
$(eval $(call TestJQT,syntax))

#
# Test macro expansion
#
.PHONY: test-expand test-mpjqt test-mpmd test-mpjson test-mpcss

test-expand: test-mpjqt test-mpmd test-mpjson test-mpcss

define TestMacroExpand
# Run one example
test-$(2)-%.$(1):
	echo "==> expand: $$(subst test-,,$$(basename $$@))"
	jqt -P $(1) tests/expand/$$(subst test-,,$$@) > tests/expand/generated/$$(subst test-,,$$@)
	diff tests/expand/expected/$$(subst test-,,$$@) tests/expand/generated/$$(subst test-,,$$@)
# Run one example named without file suffix
test-$(2)-%: test-$(2)-%.$(1) ;
# Run all tests
test-$(2): $(sort $(subst tests/expand/,test-,$(wildcard tests/expand/$(2)-[0-9][0-9].$(1))))
endef

$(eval $(call TestMacroExpand,jqt,mpjqt))
$(eval $(call TestMacroExpand,md,mpmd))
$(eval $(call TestMacroExpand,json,mpjson))
$(eval $(call TestMacroExpand,css,mpcss))

#
# Test file format conversions
#
.PHONY: test-format test-csv test-yaml

test-format: test-csv test-yaml

define TestFileFormat
# Run one example
test-$(1)-%.sh:
	echo "==> format: $$(subst test-,,$$(basename $$@))"
	$(SHELL) tests/format/$$(subst test-,,$$@)
# Run one example named without file suffix
test-$(1)-%: test-$(1)-%.sh ;
# Run all tests
test-$(1): $(sort $(subst tests/format/,test-,$(wildcard tests/format/$(1)-[0-9][0-9].sh)))
# Check output of all filters is empty for empty input
	test -z "$$$$(for f in bin/$(1)2* bin/*2$(1); do echo | $$$$f; done)" \
	|| { echo 1>&2 'EMPTY-FAILED'; false; }
endef

$(eval $(call TestFileFormat,csv))
$(eval $(call TestFileFormat,yaml))

# vim:ai:sw=8:ts=8:noet:syntax=make
