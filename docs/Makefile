########################################################################
# Makefile for web site management
#
# Project: jqt
# Author: jordinas@gmail.com <Joan Josep Ordinas Rosa>
# Published: https://fadado.github.io/jqt/
########################################################################

ifdef MAKE_RESTARTS
$(info make restarted: $(MAKE_RESTARTS))
endif

# Make configuration
include make.d/prelude.make

# jqt/yummy version
Version := $(shell cat ../VERSION)

########################################################################
# Globals and setup
########################################################################

# Metadata directory
Metadata := .meta

# Load global parameters
-include $(Metadata)/globals.make

# Defined in globals.make
# =======================
# Variables:
#	__globals__
#	Assets
#	Blocks
#	Content
#	Data
#	Destination
#	Layouts
#	Styles

# If not clobbering
ifneq (clobber,$(MAKECMDGOALS))

# Define targets for basic metadata
include make.d/config.make

# Defined in config.make
# ======================
# Targets:
# 	$(Metadata)
#	$(Metadata)/config.json
#	$(Metadata)/site.json
#	$(Metadata)/globals.make

# Build metadata from filesystem introspection
ifdef __globals__
include make.d/pathnames.make
endif

# Defined in pathnames.make
# =========================
# Variables:
#	HomePage
#	Pages
#	PagesJSON 
#	Nodes
#	NodesJSON
# Targets:
# 	$(Destination)
# 	all paths starting at $(Destination) and $(Metadata)

# Build metadata from files front-matter
ifdef __globals__

# Extra dependencies for pages
-include $(Metadata)/pages-d.make

# Extra dependencies for nodes
#-include $(Metadata)/nodes-d.make	NOT YET

# Extract front-mater from Markdown files
include make.d/front-matter.make

endif

# Defined in front-matter.make
# ============================
# Targets:
# 	JSON metadata files at $(Metadata)/pages/ and $(Metadata)/nodes/
# Additional dependencies defined:
# 	each page and node from his metadata

endif # not clobbering

# Warning:
#
# If `__globals__` is not defined because `globals.make` does not exists, after
# this point most of the file is ignored, but `globals.make` is built because a
# rule exists in the file `config.make` (only if the target is not `clobber`).
# Then `Makefile` is restarted, `MAKE_RESTARTS` will be equal to 1,
# `globals.make` is loaded and `__globals__` is defined.

########################################################################
# Commands
########################################################################

ifdef __globals__

# jqt with options
JQTFLAGS = 					\
	-5 					\
	-I./					\
	-iblocks/filters			\
	-msite:$(Metadata)/config.json		\
	-msnippets:$(Metadata)/snippets.json	\
	--toc-depth=4				\

JQT = jqt $(JQTFLAGS)

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
    
# hack to modify <detail> markup
DETAILS := sed					\
	-e 's/^<p><details><\/p>/<details>/'	\
	-e 's/^<p><\/details><\/p>/<\/details>/'\
	-e 's/^<p><summary>/<summary>/'		\
	-e 's/<\/summary><\/p>/<\/summary>/'

endif # __globals__

########################################################################
# Pages and other files to generate
########################################################################

ifdef __globals__

# Files to build or publish
Static	:= styles.css
JQT_Man := jqt.1

# Target filenames
Files	   := $(foreach f,$(Static),$(Destination)/$(f))
ManPage    := ../$(JQT_Man).gz
Targets    := $(Pages) $(Files) $(ManPage)

#
# Extra dependencies
#

# All pages
$(Pages): $(Metadata)/snippets.json

# All pages except home page
$(Destination)/styles.css:		\
	$(Blocks)/*/*style.css		\
	$(Styles)/*.css			\
	$(Styles)/*.m 			\
	$(Styles)/milligram/*.css	\

endif # __globals__

########################################################################
# Rules
########################################################################

ifdef __globals__

# Default target (always try to copy assets)
all: $(Targets)
	@cp --verbose --recursive --update $(Assets)/* $(Destination) \
	| sed "s/^.*-> ./==> /;s/.$$//"
	@echo 1>&2 'Imprimatur.'

# Snippets
$(Metadata)/snippets.json: $(Content)/snippets.yaml \
| $(Metadata)
	$(info ==> $@)
	@jqt -T < $< | yaml2json > $@

# HTML pages
define Target =
$(Destination)/$(1).html: $(Content)/$(1).md \
| $(Destination)
	$$(info ==> $$@)
	@$(JQT) -d $$< $(Layouts)/$(2).html | $(DETAILS) > $$@
endef

# TODO: introspect
home 	:= index
other	:= content data engine structure 
$(eval $(call Target,$(home),page))
$(foreach p,$(other),$(eval $(call Target,$(p),page-toc)))

# CSS stylesheet
$(Destination)/styles.css: $(Styles)/page.css
	$(info ==> $@)
	@jqt -P CSS-min -I$(Styles) < $< > $@

# Man page: jqt(1)
$(ManPage): $(Content)/$(JQT_Man).markdown
	$(info ==> $@)
	@$(GPP_MD) -I$(Content) < $<			\
	| pandoc --standalone --from markdown --to man	\
	| gzip > $@

# Generate Help text (needs explicit call: `make /tmp/help`)
/tmp/help: $(Content)/help.markdown
	$(info ==> $@)
	@jqt -P MarkDown -I$(Content) < $<				\
	| pandoc --from markdown --to plain -				\
	| sed '1,7b;/^$$/d;s/_\([A-Z]\+\)_/\1/g;/^[^A-Z]/s/^/    /'	\
	> $@

endif # __globals__

########################################################################
# Utilities
########################################################################

.PHONY: clean clobber build

ifndef __globals__

# If clobbering a not initialized project do nothing
clobber: ;@:

else

# Delete generated publications
clean:
	@rm -rf $(Destination)/* $(ManPage)

# Delete all generated files and directories
clobber:
	@rm -rf $(Destination) $(ManPage) $(Metadata)

# Build again all documents
build: clean all

# Build again all documents and metadata
xbuild:
	@touch config.yaml
	@$(MAKE) -s all

# help and other targets
include make.d/tools.make

endif # __globals__

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
