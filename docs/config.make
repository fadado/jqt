########################################################################
#
# Specific makefile for this web site.
# This should be the only makefile to edit by hand!
#
# Variables imported:
#	Metadata
#	Destination
#
# Variables modified:
# 	JQTFLAGS

########################################################################
# Build pages options.
########################################################################

# Pandoc options
JQTFLAGS += -5 --toc-depth=4

# Extra dependencies
#?$(DestinationPages): $(Blocks)/filters.jq $(Blocks)/*/*.html $(Blocks)/*/*/*.html

########################################################################
# HTML 5 validation.
########################################################################

# Download vnu.jar from `https://github.com/validator/validator/releases`.

.PHONY: valid lint

# Validation tool.
VNU := /usr/local/vnu/vnu.jar

# Validation.
valid: all
	@xmlwf $(Destination)/*.html
	@java -jar $(VNU) --errors-only --format gnu $(Destination)/*.html

# Validation with warnings.
lint: all
	@xmlwf $(Destination)/*.html
	@java -jar $(VNU) --format text $(Destination)/*.html

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
