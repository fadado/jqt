########################################################################
# Makefile.make -- Main makefile.
#
# Variables:
# 	$(Meta)
# Rules:
# 	$(Meta) directory target and clobber target
#
########################################################################

# Where all *.make files resides...
MDIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

########################################################################
# Load _Make_ configuration.
########################################################################

include $(MDIR)/configuration.make

# Do not try to rebuilt static makefiles.
$(MDIR)/Makefile.make $(MDIR)/configuration.make: ;

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
ifeq (,$(wildcard $(Meta)))
$(error Nothing to clobber)
endif
endif

## Do not build to clean immediately.
#ifeq (clean,$(filter clean,$(MAKECMDGOALS)))
#ifeq (,$(wildcard $(Meta)))
#$(error Nothing to clean)
#endif
#endif

########################################################################
# Include all makefile phases.
########################################################################

# Recursive variable used in all included makefiles. This works because the
# included files do not include other makefiles.

THIS = $(lastword $(MAKEFILE_LIST))

########################################################################
# Derive metadata from `config.yaml` or `config.json`.

-include $(Meta)/phase1.make
 include $(MDIR)/phase1.make

# Do not try to rebuilt static makefiles.
$(MDIR)/phase1.make: ;

# If `__phase_1` is not defined because `phase1.make` does not exists, after
# this point the rest of the file is ignored, but `phase1.make` is built
# because a rule exists in the file `config.make`.  Then this `Makefile` is
# restarted, `MAKE_RESTARTS` is be equal to 1, `phase1.make` is now loaded and
# `__phase_1` is defined. Equivalent situation happens in all phases.

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
 include $(MDIR)/phase3.make

# Do not try to rebuilt static makefiles.
$(MDIR)/phase3.make: ;

ifdef __phase_3
__build := 1

########################################################################
# Several complementary makefiles.

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
