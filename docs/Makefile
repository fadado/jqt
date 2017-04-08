########################################################################
# Makefile for web site management
#
# Project: jqt
# Author: jordinas@gmail.com <Joan Josep Ordinas Rosa>
# Published: https://fadado.github.io/jqt/
########################################################################

# Debug tool
ifdef MAKE_RESTARTS
$(info Makefile restarted: $(MAKE_RESTARTS))
endif

# Make configuration
include make.d/prelude.make

# jqt version
Version := $(shell cat ../VERSION)

# Metadata directory
Metadata := .meta

# Do not build to clobber immediately
ifeq (clobber,$(MAKECMDGOALS))
ifeq (,$(wildcard $(Metadata)))
$(error Nothing to clobber)
endif
endif

# ======================================================================
-include $(Metadata)/globals.make
#
# Load global parameters. If `globals.make` not exists it is built when
# restarting with a rule defined in `config.make`.
#
# Variables:
#	__globals__
#	Assets
#	Blocks
#	Content
#	Data
#	Destination
#	Layouts
#	Styles
# ======================================================================

# ======================================================================
include make.d/config.make
#
# Build files derived from user defined configuration.
#
# Imported variables:
#	Metadata
#	Version
# Exported targets:
# 	$(Metadata)
#	$(Metadata)/config.json
#	$(Metadata)/site.json
#	$(Metadata)/globals.make
# Order of dependencies:
# 	config.{yaml,json} => config.json => site.json => globals.make
# ======================================================================

# Warning:
#
# If `__globals__` is not defined because `globals.make` does not exists, after
# this point most of the file is ignored, but `globals.make` is built because a
# rule exists in the file `config.make`.  Then this `Makefile` is restarted,
# `MAKE_RESTARTS` will be equal to 1, `globals.make` is now loaded and
# `__globals__` is defined.

ifdef __globals__ # not defined in a fresh start

# ======================================================================
include make.d/pathnames.make
#
# Build metadata from filesystem introspection.
#
# Imported variables:
#	Content
#	Destination
#	Metadata
# Exported variables:
#	HomePage
#	Nodes
#	NodesJSON
#	Pages
#	PagesJSON 
# Exported targets:
# 	$(Destination)
# 	all paths starting at $(Destination) and $(Metadata)
# Additional dependencies defined:
# 	each HTML page from his metadata and directory
# 	each HTML node from his metadata and directory
# ======================================================================

# ======================================================================
include make.d/front-matter.make
#
# Collect metadata from front-matter sections.
#
# Imported variables:
#	Content
#	Metadata
# Exported targets:
# 	JSON metadata files for pages and nodes
# 	JSON files grouping other metadata files
# ======================================================================

# ======================================================================
-include $(Metadata)/html.make
#
# Load rules for pages and nodes. If not exists is built when restarting with
# rule defined in `rules.make`.
#
# Variables:
#	__html__
# Exported targets:
# 	rules for all HTML files
# ======================================================================

# Options for `jqt`.
JQTFLAGS = 					\
	-5 					\
	-I./					\
	-iblocks/filters			\
	-msite:$(Metadata)/config.json		\
	-msnippets:$(Metadata)/snippets.json	\
	--toc-depth=4				\

# ======================================================================
include make.d/rules.make
#
# Define rules for HTML pages and nodes.
#
# Imported variables:
#	Destination
#	JQTFLAGS
#	Layouts
#	Metadata
# Exported targets:
#	$(Metadata)/html.make
#
# ======================================================================

########################################################################
# Rules
########################################################################

.PHONY: clean clobber build rebuild xbuild

# Delete generated publications
clean::
	@rm -rf $(Destination)/*

# Delete all generated files and directories
clobber::
	@rm -rf $(Destination) $(Metadata)

# Build again all documents
build: clean all

#
rebuild: clobber
	@$(MAKE) -s all

# Build again all config.yaml dependents
xbuild:
	@touch config.yaml
	@$(MAKE) -s all

# Snippets
$(Metadata)/snippets.json: $(Content)/snippets.yaml \
| $(Metadata)
	$(info ==> $@)
	@jqt -T < $< | yaml2json > $@

# Extra dependencies
$(Pages): $(Metadata)/snippets.json $(Blocks)/filters.jq

# Generate CSS stylesheet
all:: $(Destination)/styles.css

# Styles
$(Destination)/styles.css:		\
	$(Blocks)/*/*style.css		\
	$(Styles)/*.css			\
	$(Styles)/*.m 			\
	$(Styles)/milligram/*.css	\

# CSS stylesheet
$(Destination)/styles.css: $(Styles)/page.css
	$(info ==> $@)
	@jqt -P CSS-min -I$(Styles) < $< > $@

# Generate man page for jqt
include make.d/man.make

# last all:: rule
all:: # copy Assets
	@cp --verbose --recursive --update $(Assets)/* $(Destination) \
	| sed "s/^.*-> ./==> /;s/.$$//"
	@echo 1>&2 'Imprimatur.'

########################################################################
# Tools
########################################################################

# Validate HTML 5
include make.d/vnu.make

# help and other targets
include make.d/tools.make

endif # __globals__

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
