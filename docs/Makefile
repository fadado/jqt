########################################################################
# Makefile
#
# Project: jqt
# Author: <Joan Josep Ordinas Rosa> jordinas@gmail.com 
# Description: Makefile for JQT web site management.
# Published: https://fadado.github.io/jqt/
#
# Variables:
# 	$(Metadata)
# Rules:
# 	$(Metadata) directory target and clobber method
#
########################################################################

########################################################################
# Load _Make_ configuration.
########################################################################

include make.d/configuration.make

# Do not try to rebuilt static makefiles.
Makefile make.d/configuration.make: ;

########################################################################
# Metadata directory for all generated make and metadata files.
########################################################################

Metadata ?= .meta

$(Metadata):
	$(info ==> $@)
	mkdir --parents $@ >/dev/null 2>&1 || true

# Delete all generated metadata
clobber:: ; @rm -rf $(Metadata)

########################################################################
# Print debug info.
########################################################################

ifneq (,$(TRACE))
ifdef MAKE_RESTARTS
$(info Makefile phase restarted: $(MAKE_RESTARTS))
endif
endif

########################################################################
# Check command line sanity.
########################################################################

# Target 'clobber' must be alone.
ifeq (clobber,$(filter clobber,$(MAKECMDGOALS)))
ifneq (1,$(words $(MAKECMDGOALS)))
$(error Target "clobber" must be alone)
endif
endif

# Do not build to clobber immediately.
ifeq (clobber,$(MAKECMDGOALS))
ifeq (,$(wildcard $(Metadata)))
$(error Nothing to clobber)
endif
endif

# Do not build to clean immediately.
ifeq (clean,$(filter clean,$(MAKECMDGOALS)))
ifeq (,$(wildcard $(Metadata)))
$(error Nothing to clean)
endif
endif

# Check _root_ intentions.
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
# Include all makefile phases.
########################################################################

# Recursive variable used in all included makefiles. This works because the
# included files do not include other makefiles.

THIS = $(lastword $(MAKEFILE_LIST))

########################################################################
# Derive metadata from `config.yaml` or `config.json`.

-include $(Metadata)/phase1.make
 include make.d/phase1.make

# Do not try to rebuilt static makefiles.
make.d/phase1.make: ;

# If `__phase_1` is not defined because `phase1.make` does not exists, after
# this point the rest of the file is ignored, but `phase1.make` is built
# because a rule exists in the file `config.make`.  Then this `Makefile` is
# restarted, `MAKE_RESTARTS` is be equal to 1, `phase1.make` is now loaded and
# `__phase_1` is defined. Equivalent situation happens in all phases.

ifdef __phase_1

########################################################################
# Build metadata from filesystem introspection.

-include $(Metadata)/phase2.make
 include make.d/phase2.make

# Do not try to rebuilt static makefiles.
make.d/phase2.make: ;

ifdef __phase_2

########################################################################
# Define standard rules and rules for HTML pages and nodes.

-include $(Metadata)/phase3.make
 include make.d/phase3.make

# Do not try to rebuilt static makefiles.
make.d/phase3.make: ;

ifdef __phase_3

########################################################################
# Several complementary makefiles.

include make.d/sitemap.make
include make.d/styles.make
##include make.d/tools.make

# Do not try to rebuilt static makefiles.
make.d/sitemap.make: ;
make.d/styles.make: ;
##make.d/tools.make: ;

########################################################################
# Project specific makefile. All the previous modules are expected to be
# independent, valid for any project without any change. This file must
# exist but can be empty.

include config.make

# Do not try to rebuilt static makefiles.
config.make: ;

endif # __phase_3
endif # __phase_2
endif # __phase_1

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
