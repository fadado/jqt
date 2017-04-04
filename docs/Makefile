# jqt documentation management

include make.d/config.make

########################################################################
# Variables
########################################################################

# Metadata directory
Metadata := .yummy

# Output directory
Destination := /tmp/jqt

# Input files directories 
Assets  := ./assets
Blocks  := ./blocks
Content := ./content
Data    := ./data
Layouts := ./blocks
Styles  := ./styles

# Files to build or publish
Home 	:= index
Other	:= content data engine structure 
Static	:= styles.css

# Target filenames
ManPage    := ../jqt.1.gz
HomePage   := $(Destination)/$(Home).html
OtherPages := $(foreach p,$(Other),$(Destination)/$(p).html)
Files	   := $(foreach f,$(Static),$(Destination)/$(f))
Pages  	   := $(HomePage) $(OtherPages)
Targets    := $(Pages) $(Files) $(ManPage)

########################################################################
# jqt command with options
########################################################################

# jqt with options
JQTFLAGS := \
	-5 					\
	-I./					\
	-iblocks/filters			\
	-msite:$(Metadata)/config.json		\
	-msnippets:$(Metadata)/snippets.json	\
	--toc-depth=4				\

JQT = jqt $(JQTFLAGS)

# gpp for the man page (to be build without calling jqt!)
GPP_MD_FLAGS := \
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
    
GPP_MD = gpp $(GPP_MD_FLAGS)

# hack to modify <detail> markup
DETAILS := sed					\
	-e 's/^<p><details><\/p>/<details>/'	\
	-e 's/^<p><\/details><\/p>/<\/details>/'\
	-e 's/^<p><summary>/<summary>/'		\
	-e 's/<\/summary><\/p>/<\/summary>/'

########################################################################
# Extra dependencies
########################################################################

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

########################################################################
# Rules
########################################################################

all: $(Targets) cp_assets

# Destination directory
$(Destination):
	$(info ==> $@)
	mkdir $@ >/dev/null 2>&1 || true

# Copy assets
cp_assets: | $(Destination)
	cp --verbose --recursive --update $(Assets)/* $(Destination)

# Include metadata
include make.d/metadata.make

# Snippets
$(Metadata)/snippets.json: $(Content)/snippets.yaml \
| $(Metadata)
	$(info ==> $@)
	jqt -T < $< | yaml2json > $@

# HTML pages
define Target
$(Destination)/$(1).html: $(Content)/$(1).md $(Layouts)/$(2).html \
| $(Destination)
	$$(info ==> $$@)
	$(JQT) -d $$< $(Layouts)/$(2).html | $(DETAILS) > $$@
endef

$(eval $(call Target,$(Home),page))
$(foreach p,$(Other),$(eval $(call Target,$(p),page-toc)))

# CSS stylesheet
$(Destination)/styles.css: $(Styles)/page.css
	$(info ==> $@)
	jqt -P CSS-min -I$(Styles) < $< > $@

# Man page: jqt(1)
$(ManPage): $(Content)/jqt.1.markdown
	$(info ==> $@)
	$(GPP_MD) -I$(Content) < $<			\
	| pandoc --standalone --from markdown --to man	\
	| gzip > $@

########################################################################
# Utilities
########################################################################

.PHONY: clean clobber build help valid lint

clean:
	rm -rf $(Destination)/* $(ManPage)

clobber: clean
	rm -rf $(Destination) $(Metadata)

build: clean all

# Show targets
help:
	echo 'Targets:';					\
	$(MAKE) --print-data-base --just-print 2>&1		\
	| grep -v '^[mM]akefile'				\
	| awk '/^[^ \t.%][-A-Za-z0-9_]*:/ { print $$1 }'	\
	| sort --unique						\
	| sed 's/:\+$$//'					\
	| pr --omit-pagination --indent=4 --width=80 --columns=4

# Validation using vnu.jar
VNU := /usr/local/vnu/vnu.jar
valid: all
	xmlwf $(Destination)/*.html
	java -jar $(VNU) --errors-only --format gnu $(Destination)/*.html

# Validation with warnings using vnu.jar
lint: all
	xmlwf $(Destination)/*.html
	java -jar $(VNU) --format text $(Destination)/*.html

# Generate Help text (need explicit call: `make /tmp/help`)
/tmp/help: $(Content)/help.markdown
	$(info ==> $@)
	jqt -P MarkDown -I$(Content) < $<				\
	| pandoc --from markdown --to plain -				\
	| sed '1,7b;/^$$/d;s/_\([A-Z]\+\)_/\1/g;/^[^A-Z]/s/^/    /'	\
	> $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
