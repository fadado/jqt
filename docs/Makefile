########################################################################
# Makefile for web site management
#
# Project: jqt
# Author: <Joan Josep Ordinas Rosa> jordinas@gmail.com 
# Published: https://fadado.github.io/jqt/
########################################################################

# Make configuration
include make.d/prelude.make

# jqt version
Version := 0.5.1

# Metadata directory
Metadata := .meta

# Do not build to clobber immediately
ifeq (clobber,$(MAKECMDGOALS))
ifeq (,$(wildcard $(Metadata)))
$(error Nothing to clobber)
endif
endif

# Do not build to clean immediately
ifeq (clean,$(filter clean,$(MAKECMDGOALS)))
ifeq (,$(wildcard $(Metadata)))
$(error Nothing to clean)
endif
endif

# ======================================================================
-include $(Metadata)/phase1.make
 include make.d/config.make
#
# Variables defined in phase1.make:
#	__phase_1
#	Assets
#	Blocks
#	Content
#	Data
#	Destination
#	Layouts
#	Styles
# Defined rules for:
# 	$(Metadata)
#	$(Metadata)/config.json
#	$(Metadata)/phase1.make
#	$(Metadata)/site.json
# ======================================================================

# Warning:
#
# If `__phase_1` is not defined because `phase1.make` does not exists, after
# this point most of the file is ignored, but `phase1.make` is built because a
# rule exists in the file `config.make`.  Then this `Makefile` is restarted,
# `MAKE_RESTARTS` is be equal to 1, `phase1.make` is now loaded and
# `__phase_1` is defined. Equivalent situation happens in all phases.

ifdef __phase_1

# ======================================================================
-include $(Metadata)/phase2.make
 include make.d/data.make
#
# Variables defined in phase2.make:
#	__phase_2
#	DataCSV
#	DataJSON
#	DataMD
#	DataYAML
#	DestinationPages
#	DestinationPaths
#	MetadataPages 
#	MetadataPaths
# Defined rules for:
#	$(Metadata)/phase2.make
# 	$(DataFiles)
# 	$(DestinationPaths)
# 	$(Metadata)/pages-by-id.json
# 	$(MetadataPages)
# 	$(MetadataPaths)
# Defined targets:
# 	init
# ======================================================================

ifdef __phase_2

# ======================================================================
-include $(Metadata)/phase3.make
 include make.d/pages.make
#
# Load rules for pages and nodes.
#
# Variables defined in phase3.make:
#	__phase_3
# Defined rules for:
#	$(Metadata)/phase3.make
# Defined targets:
#	all
# 	build
# 	clean
# 	clobber
# 	fresh
# 	touch
# ======================================================================

ifdef __phase_3

# ======================================================================
include make.d/sitemap.make
include make.d/styles.make
include make.d/tools.make
#
# Several complementary files.
#
# Defined rules for:
#	$(Destination)/sitemap.xml
#	$(Destination)/sitemap.xml.gz
#	$(Destination)/styles.css
# Defined targets:
# 	help
# 	lint
# 	valid
# ======================================================================

########################################################################
include config.make
#
# Project specific makefile. All the previous modules are expected to be
# independent, valid for any project without any change.
#
# Defined rules for:
#	$(ManPage)
#	/tmp/help
# Defined targets:
# 	all
# 	clean
# 	clobber
########################################################################

endif # __phase_3
endif # __phase_2
endif # __phase_1

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
