########################################################################
#
# Specific makefile for this web site.
# This should be the only makefile to edit by hand!
#
# Variables imported:
#	Metadata
#
# Variables modified:
# 	JQTFLAGS

########################################################################
# Build pages options
########################################################################

# Append parameters to:
JQTFLAGS += -msnippets:$(Metadata)/snippets.json  

# Pandoc options
JQTFLAGS += -5 --toc-depth=4

# Extra dependencies
#?$(DestinationPages): $(Blocks)/filters.jq $(Blocks)/*/*.html $(Blocks)/*/*/*.html

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
