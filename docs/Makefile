########################################################################
# Project: jqt
# Author: <Joan Josep Ordinas Rosa> jordinas@gmail.com 
# Description: Makefile for JQT web site management.
# Published: https://fadado.github.io/jqt/
#
# Project specific makefile. All the imported modules are expected to be
# independent, valid for any project without any change.  This should be
# the only makefile to edit by hand!
#
# Variables used:
#	Root
#
# Variables modified:
# 	JQTFLAGS

#Meta := .meta
#VERBOSE := 1
#TRACE := 1

include make.d/Makefile.make

# Last phase, after metadata configuration.
ifdef __build

########################################################################
# Build pages options.
########################################################################

# Pandoc options
JQTFLAGS += -5 --toc-depth=4

########################################################################
# HTML 5 validation.
########################################################################

# Download vnu.jar from `https://github.com/validator/validator/releases`.

.PHONY: h5.valid h5.lint

# Validation tool.
VNU := /usr/local/vnu/vnu.jar

# Validation.
h5.valid: build
	@xmlwf $(Root)/*.html
	@java -jar $(VNU) --errors-only --format gnu $(Root)/*.html

# Validation with warnings.
h5.lint: build
	@xmlwf $(Root)/*.html
	@java -jar $(VNU) --format text $(Root)/*.html

endif # __build

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
