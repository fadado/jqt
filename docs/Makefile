# jqt documentation management

include make.d/config.make

########################################################################
# Globals and setup
########################################################################

# Metadata directory
Metadata := .yummy

# Load global parameters
-include $(Metadata)/globals.make

# Defined in globals.make:
#    __globals__
#    Assets
#    Blocks
#    Content
#    Data
#    Destination
#    Layouts
#    Styles

# If not clobbering
ifneq (clobber,$(MAKECMDGOALS))

# Define targets for basic metadata
include make.d/metadata.make

# Build metadata from introspection
ifdef __globals__
include make.d/introspect.make
endif

# Defined in introspect.make:
#	HomePage
#	Pages
#	OtherPages

endif # not clobbering

# Warning:
#
# If `__globals__` is not defined because `globals.make` does not exists, after
# this point most of the file is ignored, but `globals.make` is built because a
# rule exists in the file `metadata.make` (only if the target is not `clobber`).
# Then `Makefile` is restarted, `MAKE_RESTARTS` will be equal to 1,
# `globals.make` is loaded and `__globals__` is defined.

########################################################################
# jqt command with options
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
Home 	:= index
Other	:= content data engine structure 
Static	:= styles.css
JQT_Man := jqt.1

# Target filenames
Files	   := $(foreach f,$(Static),$(Destination)/$(f))
ManPage    := ../$(JQT_Man).gz
Targets    := $(Pages) $(Files) $(ManPage)

#
# Extra dependencies
#

$(Pages): \
	$(Blocks)/*/markup.html		\
	$(Blocks)/filters.jq		\
	$(Content)/LINKS.txt		\
	$(Content)/macros.m		\
	$(Metadata)/config.json		\
	$(Metadata)/snippets.json	\


$(OtherPages):			\
	$(Content)/FLOW.txt	\
	$(Layouts)/page.html	\
	$(Content)/opt/*.txt	\

$(HomePage) 			\
$(Destination)/structure.html:	\
	$(Content)/EXAMPLE.txt	\

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

# Default target
all: static $(Targets)
	@echo 1>&2 'Imprimatur.'

# Copy assets
static: | $(Destination)
	@cp --verbose --recursive --update $(Assets)/* $(Destination) \
	| sed "s/^.*-> ./==> /;s/.$$//"

# Snippets
$(Metadata)/snippets.json: $(Content)/snippets.yaml \
| $(Metadata)
	$(info ==> $@)
	@jqt -T < $< | yaml2json > $@

# HTML pages
define Target
$(Destination)/$(1).html: $(Content)/$(1).md $(Layouts)/$(2).html \
| $(Destination)
	$$(info ==> $$@)
	@$(JQT) -d $$< $(Layouts)/$(2).html | $(DETAILS) > $$@
endef

$(eval $(call Target,$(Home),page))
$(foreach p,$(Other),$(eval $(call Target,$(p),page-toc)))

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

.PHONY: clean clobber build help

# Show targets
help:
	@echo 'Usage: make TARGET [parameter=value...]'
	@echo 'Targets:';					\
	$(MAKE) --print-data-base --just-print 2>&1		\
	| grep -v '^[mM]akefile'				\
	| awk '/^[^ \t.%][-A-Za-z0-9_]*:/ { print $$1 }'	\
	| sort --unique						\
	| sed 's/:\+$$//'					\
	| pr --omit-pagination --indent=4 --width=80 --columns=4

ifndef __globals__

clobber: ;

else

clean:
	@rm -rf $(Destination)/* $(ManPage)

clobber:
	@rm -rf $(Destination) $(ManPage) $(Metadata)

build: clean all

.PHONY: valid lint

# Validation using vnu.jar
VNU := /usr/local/vnu/vnu.jar
valid: all
	@xmlwf $(Destination)/*.html
	@java -jar $(VNU) --errors-only --format gnu $(Destination)/*.html

# Validation with warnings using vnu.jar
lint: all
	@xmlwf $(Destination)/*.html
	@java -jar $(VNU) --format text $(Destination)/*.html

endif # __globals__

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
