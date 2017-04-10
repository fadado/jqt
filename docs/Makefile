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
# Exported variables:
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
# Build files derived from user defined configuration:
# 	config.{yaml,json} => config.json => site.json => globals.make
#
# Imported variables:
#	Metadata
#	Version
# Exported rules for:
# 	$(Metadata)
#	$(Metadata)/config.json
#	$(Metadata)/site.json
#	$(Metadata)/globals.make
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
# Exported rules for:
# 	$(Destination)
# 	$(Destination)/.../
# 	$(Metadata)/.../
#	all:: $(Pages)
# Additional dependencies defined:
# 	$(Destination)/.../page.html => $(Metadata)/pages/.../page.json
# 	$(Destination)/.../section/index.html => $(Metadata)/nodes/.../section.json
# ======================================================================

# ======================================================================
include make.d/front-matter.make
#
# Collect metadata from front-matter sections.
#
# Imported variables:
#	Content
#	Metadata
# Exported rules for:
# 	$(Metadata)/pages/.../page.json
# 	$(Metadata)/nodes/.../section.json
# 	$(Metadata)/pages.json
# 	$(Metadata)/nodes.json
# 	$(Metadata)/sections.json
# ======================================================================

# ======================================================================
-include $(Metadata)/html.make
#
# Load rules for pages and nodes. If not exists is built when restarting with
# rule defined in `pages.make`.
#
# Exported variables:
#	__html__
# Exported rules for:
# 	rules for all HTML files
# ======================================================================

ifdef __html__

# Options for `jqt`. To be extended in the site specific section.
JQTFLAGS = \
	-I./				\
	-msite:$(Metadata)/config.json	\

endif

# ======================================================================
include make.d/pages.make
#
# Define standard rules and rules for HTML pages and nodes.
#
# Imported variables:
#	Assets
#	Destination
#	Layouts
#	Metadata
#	JQTFLAGS
# Exported rules for:
#	$(Metadata)/html.make
#	all:: # assets
# 	build
# 	clean::
# 	clobber::
# 	xbuild
# 	xxbuild
# ======================================================================

# ======================================================================
include make.d/sitemap.make
#
# Define rules for sitemap.
#
# Imported variables:
#	Destination
#	Metadata
# Exported rules for:
#	$(Destination)/sitemap.*
#	all:: $(Destination)/sitemap.*
# ======================================================================

# ======================================================================
include make.d/styles.make
# 
# Build CSS main stylesheet.
#
# Imported variables:
#	Destination
#	Blocks
#	Styles
# Exported rules for:
#	$(Destination)/styles.css
# 	all:: $(Destination)/styles.css
# ======================================================================

# ======================================================================
include make.d/tools.make
# 
# Tools independent of any target.
#
# Parameters:
# 	vnudir
# Imported variables:
#	Destination
# Exported rules for:
# 	help
# 	valid
# 	lint
# ======================================================================

########################################################################
#  Specific rules for this web site
########################################################################

ifdef __html__

# Options for `jqt`.
JQTFLAGS += 					\
	-5 					\
	-iblocks/filters			\
	-msnippets:$(Metadata)/snippets.json	\
	--toc-depth=4				\

# Snippets
$(Metadata)/snippets.json: $(Content)/snippets.yaml \
| $(Metadata)
	$(info ==> $@)
	@jqt -T < $< | yaml2json > $@

# Extra dependencies
$(Pages): $(Metadata)/snippets.json $(Blocks)/filters.jq

#
# Generate man page for jqt
#

# gpp for the man page (to be build without calling jqt!)
GPP_MD := gpp						\
	-U '<%' '>' '\B' '\B' '\W>' '<' '>' '$$' ''	\
	-M '<%' '>' '\B' '\B' '\W>' '<' '>'		\
	+sccc '&\n' '' ''				\
	+sccc '\\n' '' ''				\
	+sccc '<\#' '\#>\n' ''				\
	+siqi "'" "'" '\'				\
	+siQi '"' '"' '\'				\
	+ssss '<!--' '-->' ''				\
	+ssss '`'  '`' ''				\
	+ssss '\n```' '\n```' ''			\
	+ssss '\n~~~' '\n~~~' ''			\
    
#
ManPage := ../jqt.1.gz

# Man page: jqt(1)
$(ManPage): $(Content)/jqt.1.markdown
	$(info ==> $@)
	@$(GPP_MD) -I$(Content) < $<			\
	| pandoc --standalone --from markdown --to man	\
	| gzip > $@

# Add prerequisites and recipes to common targets
all:: $(ManPage)

clean::
	@rm -f $(ManPage)

clobber::
	@rm -f $(ManPage)

########################################################################
# Generate Help text
# Independent target: helps generating text for `jqt -h`
# Needs explicit call: `make /tmp/help`
#
/tmp/help: $(Content)/help.markdown
	$(info ==> $@)
	@jqt -P MarkDown -I$(Content) < $<				\
	| pandoc --from markdown --to plain -				\
	| sed '1,7b;/^$$/d;s/_\([A-Z]\+\)_/\1/g;/^[^A-Z]/s/^/    /'	\
	> $@

clean::
	@rm -f /tmp/help

endif # __html__
endif # __globals__

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
