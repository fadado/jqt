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

# Paranoia
ifeq (,$(filter install uninstall,$(MAKECMDGOALS)))
ifeq (0,$(shell id --user))
$(error  Root only can make "(un)install" targets)
endif
SUDO := 
else
SUDO := sudo
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
.PHONY: all

# When a target is built all lines of the recipe will be given to a
# single invocation of the shell.
# !!!Does not work in  make <= 3.82 event it is documented!!!
#.ONESHELL:

# Default shell: if we require GNU Make, why not require Bash?
SHELL := /bin/bash

# The argument(s) passed to the shell are taken from the variable
# .SHELLFLAGS.
.SHELLFLAGS := -o errexit -o pipefail -o nounset -c

# Make will delete the target of a rule if it has changed and its recipe
# exits with a nonzero exit status.
.DELETE_ON_ERROR:

########################################################################
# Rules
########################################################################

# Warning: only `dnf`! Use this rule as template to your own script.
setup:
	@rpm -q --quiet general-purpose-preprocessor || sudo dnf -y install general-purpose-preprocessor
	@rpm -q --quiet jq || sudo dnf -y install jq
	@rpm -q --quiet pandoc || sudo dnf -y install pandoc
	@test -d /usr/share/doc/PyYAML || sudo dnf -y install PyYAML

# Default target
all: check

########################################################################
# Utilities
########################################################################

.PHONY: clean clobber install uninstall

clean:
	rm -f tests/*/generated/* jqt.1.gz

clobber: clean

install:
	[[ -e jqt.1.gz ]] || { cd docs && make ../jqt.1.gz; }
	test -d $(bindir) || $(SUDO) mkdir --verbose --parents $(bindir)
	test -d $(datadir)/$(PROJECT) || $(SUDO) mkdir --verbose --parents $(datadir)/$(PROJECT)
	test -d $(mandir)/man1 || $(SUDO) mkdir --verbose --parents $(mandir)/man1
	$(SUDO) install --verbose --compare --mode 555 bin/* $(bindir)
	$(SUDO) install --verbose --compare --mode 644 share/* $(datadir)/$(PROJECT)
	$(SUDO) install --verbose --compare --mode 644 jqt.1.gz $(mandir)/man1
	$(SUDO) sed -i -e "s#DATADIR='.*'#DATADIR='$(datadir)'#" $(bindir)/jqt

uninstall:
	$(SUDO) rm --verbose --force -- $(addprefix $(prefix)/,$(wildcard bin/*))
	$(SUDO) rm --verbose --force -- $(mandir)/man1/jqt.1.gz
	test -d $(datadir)/$(PROJECT)					  \
	&& $(SUDO) rm --verbose --force --recursive $(datadir)/$(PROJECT) \
	|| true

# Show targets
.PHONY: help
help:
	echo 'Usage: make TARGET [parameter=value...]'
	echo 'Targets:';					\
	$(MAKE) --print-data-base --just-print 2>&1		\
	| grep -v '^[mM]akefile'				\
	| awk '/^[^ \t.%][-A-Za-z0-9_]*:/ { print $$1 }'	\
	| sort --unique						\
	| sed 's/:\+$$//'					\
	| pr --omit-pagination --indent=4 --width=80 --columns=4
	echo 'Default parameters:';				\
	echo '    prefix    = /usr/local';			\
	echo '    bindir    = /usr/local/bin';			\
	echo '    datadir   = /usr/local/share';		\
	echo '    mandir    = /usr/local/share/man'

########################################################################
# Tests
########################################################################

.PHONY: check
check: test-jqt test-expand test-format

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
