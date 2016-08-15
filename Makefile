# jqt management
#

project := jqt

########################################################################
# Parameters (redefine as you like)
########################################################################

prefix	?= /usr/local
bindir	?= $(prefix)/bin
datadir	?= $(prefix)/share

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
ifeq (0,$(shell id --user))
ifeq (,$(filter install uninstall,$(MAKECMDGOALS)))
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
	rm -f tests/generated/*

clobber: clean

install:
	test -d $(bindir) || $(SUDO) mkdir --verbose --parents $(bindir)
	test -d $(datadir)/$(project) || $(SUDO) mkdir --verbose --parents $(datadir)/$(project)
	$(SUDO) install --verbose --compare --mode 555 bin/* $(bindir)
	$(SUDO) install --verbose --compare --mode 644 share/* $(datadir)/$(project)

uninstall:
	$(SUDO) rm --verbose --force -- $(addprefix $(prefix)/,$(wildcard bin/*))
	test -d $(datadir)/$(project) \
	&& $(SUDO) rm --verbose --force --recursive $(datadir)/$(project) \
	|| true

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

########################################################################
# Tests
########################################################################

.PHONY: check jqt format cond expr loop macros syntax expand csv yaml

check: expand jqt format
jqt: cond expr loop macros syntax
format: csv yaml

define TestJQT
# Run one example
$(1)-%.jqt:
	echo "==> $$(basename $$@)"
	if [[ -e tests/$$(basename $$@).json ]]; then \
	    jqt -ifilters -Ltests/filters -Mtop:tests/$$(basename $$@).json -dtests/md-00.md tests/$$@ tests/generated/$$(basename $$@).txt; \
	else \
	    jqt -ifilters -Ltests/filters -dtests/md-00.md tests/$$@ tests/generated/$$(basename $$@).txt; \
	fi
	diff tests/expected/$$(basename $$@).txt tests/generated/$$(basename $$@).txt
# Run one example named without file suffix
$(1)-%: $(1)-%.jqt ;
# Run all tests
$(1): $(sort $(subst tests/,,$(wildcard tests/$(1)-[0-9][0-9].jqt)))
endef

$(foreach t,cond expr loop macros syntax,$(eval $(call TestJQT,$(t))))

define TestGPP
# Run one example
$(2)-%.$(1):
	echo "==> $$(basename $$@)"
	jqt -E tests/$$@ > tests/generated/$$@
	diff tests/expected/$$@ tests/generated/$$@
# Run one example named without file suffix
$(2)-%: $(2)-%.$(1) ;
# Run all tests
$(2): $(sort $(subst tests/,,$(wildcard tests/$(2)-[0-9][0-9].$(1))))
endef

$(eval $(call TestGPP,jqt,expand))

define TestFileFormat
# Run one example
$(1)-%.sh:
	echo "==> $$(basename $$@)"
	$(SHELL) tests/$$@
# Run one example named without file suffix
$(1)-%: $(1)-%.sh ;
# Run all tests
$(1): $(sort $(subst tests/,,$(wildcard tests/$(1)-[0-9][0-9].sh)))
# Check output of all filters is empty for empty input
	test -z "$$$$(for f in bin/$(1)2* bin/*2$(1); do echo | $$$$f; done)" \
	|| { echo 1>&2 'EMPTY-FAILED'; false; }
endef

$(foreach t,csv yaml,$(eval $(call TestFileFormat,$(t))))

# vim:ai:sw=8:ts=8:noet:syntax=make
