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
-include $(Metadata)/phase1.make
#
# Load site global parameters. If `phase1.make` not exists it is built when
# restarting with a rule defined in `config.make`.
#
# Exported variables:
#	__phase_1
#	Assets
#	Blocks
#	Content
#	Data
#	Destination
#	Layouts
#	Styles
# ======================================================================

include make.d/config.make

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
#
# Load variables for several pathnames.
#
# Exported variables:
#	__phase_2
#	DestinationPages
#	DestinationPaths
#	MetadataPages 
#	MetadataPaths
# Exported dependencies:
# 	$(Metadata)/pages/.../page.json: | $$(dir $$@)
# ======================================================================

include make.d/pathnames.make

ifdef __phase_2

include make.d/front-matter.make

# ======================================================================
-include $(Metadata)/phase3.make
#
# Load rules for pages and nodes. If not exists is built when restarting with
# rule defined in `pages.make`.
#
# Exported variables:
#	__phase_3
# Exported rules for:
# 	dependencies and rules for all HTML files
# ======================================================================

include make.d/pages.make

ifdef __phase_3

include make.d/sitemap.make
include make.d/styles.make
include make.d/tools.make

########################################################################
#  Specific rules for this web site
########################################################################

# Call jqt with user defined flags
JQT = jqt $(JQTFLAGS)

# Options for `jqt`.
JQTFLAGS += 					\
	-5 					\
	-I./					\
	-j'$$'pages:$(Metadata)/pages		\
	-msite:$(Metadata)/config.json		\
	-msections:$(Metadata)/sections.json	\
	-iblocks/filters			\
	--toc-depth=4				\
	-msnippets:$(Metadata)/snippets.json	\

# Snippets
$(Metadata)/snippets.json: $(Data)/snippets.yaml \
| $(Metadata)
	$(info ==> $@)
	@jqt -T < $< | yaml2json > $@

# Extra dependencies
$(DestinationPages): $(Metadata)/snippets.json $(Blocks)/filters.jq $(Blocks)/*/*.html $(Blocks)/*/*/*.html

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
$(ManPage): $(Content)/jqt.1.text
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
/tmp/help: $(Content)/help.text
	$(info ==> $@)
	@jqt -P MarkDown -I$(Content) < $<				\
	| pandoc --from markdown --to plain -				\
	| sed '1,7b;/^$$/d;s/_\([A-Z]\+\)_/\1/g;/^[^A-Z]/s/^/    /'	\
	> $@

clean::
	@rm -f /tmp/help

endif # __phase_3
endif # __phase_2
endif # __phase_1

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
