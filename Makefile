# jqt management
#

project=jqt

include make.d/config.make
include make.d/debug.make

########################################################################
# Parameters (redefine as you like)
########################################################################

prefix	?= /usr/local
bindir	?= $(prefix)/bin
datadir	?= $(prefix)/share

########################################################################
# Rules
########################################################################

# Configure tools
include make.d/setup.make

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
