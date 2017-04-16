########################################################################
# tools.make
#
# Tools.
#
# Parameters:
# 	vnudir
# Imported variables:
#	Destination
# Exported rules for:
# 	help
# 	valid
# 	lint

########################################################################
# Show all targets
########################################################################

.PHONY: help

# Warning: `make help` can build several phases.
help:
	@echo 'Usage: make TARGET [parameter=value...]'
	@echo 'Targets:';					\
	$(MAKE) --print-data-base --just-print 2>&1		\
	| grep -v '^[mM]akefile'				\
	| awk '/^[^ \t.%][-A-Za-z0-9_]*:/ { print $$1 }'	\
	| sort --unique						\
	| sed 's/:\+$$//'					\
	| pr --omit-pagination --indent=4 --width=80 --columns=4\
	|| true

########################################################################
# HTML 5 validation
########################################################################

.PHONY: valid lint

# Parameter, definable at runtime
vnudir ?= /usr/local/vnu

# Validation tool
VNU := $(vnudir)/vnu.jar

# Validation
valid: all
	@xmlwf $(Destination)/*.html
	@java -jar $(VNU) --errors-only --format gnu $(Destination)/*.html

# Validation with warnings
lint: all
	@xmlwf $(Destination)/*.html
	@java -jar $(VNU) --format text $(Destination)/*.html

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
