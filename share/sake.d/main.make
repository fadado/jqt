########################################################################
# main.make -- Main makefile.
#
# Imported variables:
# 	JQTLIB
#
# Variables:
# 	Meta
# Rules:
# 	$(Meta) directory `mkdir`, `clobber'  and ' clean'  targets
# 	$(Root) directory `mkdir`, `clobber'  and ' clean'  targets
# Targets:
#	build
# 	clean
# 	clobber
# 	nuke
# 	configure
#
########################################################################

########################################################################
# Load _Make_ configuration.
########################################################################

# Where all *.make files resides...
MDIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

include $(MDIR)/configuration.make

# Do not try to rebuilt static makefiles.
$(CURDIR)/Sakefile $(MDIR)/main.make $(MDIR)/configuration.make: ;

########################################################################
# Print debug info.
########################################################################

ifneq (,$(TRACE))
ifdef MAKE_RESTARTS
$(info Makefile phase restarted: $(MAKE_RESTARTS))
endif
endif

########################################################################
# Metadata directory for all generated make and metadata files.
########################################################################

Meta ?= .meta

$(Meta):
	$(info ==> $@)
	mkdir --parents $@ >/dev/null 2>&1 || true

# Delete all generated metadata
clobber:: ; @rm -rf $(Meta)

########################################################################
# Check command line sanity.
########################################################################

# Check only one target is present.
ifneq (1,$(words $(MAKECMDGOALS)))
$(error Only one target accepted)
endif

# Do not remake $(Meta)/phase[123].make to clobber immediately.
ifeq (clobber,$(MAKECMDGOALS))
ifeq (,$(wildcard $(Meta)))
$(error Nothing to clobber)
endif
endif

########################################################################
# Include all makefile phases.
########################################################################

# Recursive variables used in all included makefiles.

# Current makefile.
# $(THIS) works because the included files do not include other makefiles.
THIS = $(lastword $(MAKEFILE_LIST))

# JQ script generating target
SCRIPT = $(MDIR)/$$(basename $$(notdir $$@)).jq

########################################################################
# Derive metadata from `config.yaml` or `config.json`.

-include $(Meta)/phase1.make
 include $(MDIR)/phase1.make

# Do not try to rebuilt static makefiles.
$(MDIR)/phase1.make: ;

# If `__phase_1` is not defined because `$(Meta)/phase1.make` does not
# exists, after this point the rest of the file is ignored, but
# `$(Meta)/phase1.make` is built because a rule exists in the file
# `$(MDIR)/phase1.make`.  Then this `Makefile` is restarted,
# `MAKE_RESTARTS` is be equal to 1, `$(Meta)/phase1.make` is now loaded
# and `__phase_1` is defined. Equivalent situation happens in all phases.

ifdef __phase_1

########################################################################
# Build metadata from filesystem introspection.

-include $(Meta)/phase2.make
 include $(MDIR)/phase2.make

# Do not try to rebuilt static makefiles.
$(MDIR)/phase2.make: ;

ifdef __phase_2

########################################################################
# Define standard rules and rules for HTML pages and nodes.

-include $(Meta)/phase3.make
-include $(Meta)/phase3d.make
 include $(MDIR)/phase3.make

# Do not try to rebuilt static makefiles.
$(MDIR)/phase3.make: ;

ifdef __phase_3
__build := 1

########################################################################
# Standard targets.
########################################################################

sake_builtin := new help touch list
.PHONY: build clean clobber nuke configure $(sake_builtin)

# Filter builtin tools defined in `sake`script.
$(sake_builtin): ; @echo 'sake: Target `$@` not implemented.'

# Copy Assets after create HTML pages.
build:: $(PagesHTML)
	@cp --verbose --recursive --update $(Assets)/* $(Root) \
	| sed "s/^.*-> ./==> /;s/.$$//"
	date -Iseconds > $(Meta)/lastbuild

# Delete secondary files.
clobber:: ; @rm -rf *~ *.bak  *.log

# Delete metadata. Usage: `sake nuke && sake configure`.
nuke: ; @rm -rf $(Meta)

# Build all metadata and data files.
configure: $(DataFiles)	# $(PagesJSON) are built for phase2.make

########################################################################
# Site destination directory.

$(Root):
	$(info ==> $@)
	mkdir --parents $@ >/dev/null 2>&1 || true

# Delete generated files. Usage: `sake clean && sake`.
clean: ; @rm -rf $(Root)/*

# Delete destination directory.
clobber:: ; @rm -rf $(Root)

########################################################################
# Several complementary makefiles.
########################################################################

include $(MDIR)/sitemap.make
include $(MDIR)/styles.make
include $(MDIR)/tools.make

# Do not try to rebuilt static makefiles.
$(MDIR)/sitemap.make: ;
$(MDIR)/styles.make: ;
$(MDIR)/tools.make: ;

endif # __phase_3
endif # __phase_2
endif # __phase_1

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
