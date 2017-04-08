########################################################################
# HTML 5 validation
########################################################################

# Parameters:
# 	vnudir
# Imported variables:
#	Destination
# Exported targets:
# 	valid
# 	lint

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
