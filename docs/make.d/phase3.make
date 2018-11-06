########################################################################
# phase3.make -- Define standard rules and rules for HTML pages and nodes.
#
# Rules defined in $(Metadata)/phase3.make:
# 	all HTML target files
#
# Rules defined in make.d/phase3.make:
#	$(Metadata)/phase3.make
#
# Targets defined in make.d/phase3.make:
#	all
# 	build
# 	clean
# 	clobber
# 	dbg.meta
# 	dbg.fresh
# 	dbg.touch

SUPER := $(Metadata)/phase2.make

########################################################################
# Create makefile containing rules for all HTML files.
########################################################################

# Build rules for each page.
$(Metadata)/phase3.make: $(Metadata)/pages-by-id.json make.d/phase3.jq $(SUPER) $(THIS)
	$(info ==> $@)
	jq --raw-output				\
	   --arg Metadata $(Metadata)		\
	   --arg Layouts $(Layouts)		\
	   --arg Destination $(Destination)	\
	   --from-file make.d/phase3.jq		\
	   < $< > $@

ifdef __phase_3

#
# Variables used in `$(Metadata)/phase3.make`.
#

define JQTFLAGS :=
  -msite:$(Metadata)/site.json	\
  -I./				\
  -L$(Metadata)			\
  -L$(Blocks)			\
  -ifilters
endef

JQT = jqt $(JQTFLAGS)

define DETAILS :=
  sed -e 's/^<p><details><\/p>/<details>/'	\
      -e 's/^<p><\/details><\/p>/<\/details>/'	\
      -e 's/^<p><summary>/<summary>/'		\
      -e 's/<\/summary><\/p>/<\/summary>/'
endef

#
# Extra prerequisites for HTML pages.
#

$(PagesHTML): $(Destination)/%.html : $(Metadata)/pages/%.json
$(PagesHTML): $(Metadata)/phase3.make $(Blocks)/*/markup.html $(Blocks)/*/*/markup.html \
| $$(dir $$@)
ifneq (,$(DataFiles))
$(PagesHTML): $(DataFiles)
endif

# Content example for `$(Metadata)/phase3.make`:

# __phase_3 := 1
# _site/jqt/index.html: content/index.md layouts/page.html content/macros.m content/LINKS.txt content/EXAMPLE.txt
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/index.json layouts/page.html | $(DETAILS) > $@
# ...
# _site/jqt/blog/2017-04-13-hello.html: content/blog/2017-04-13-hello.md layouts/page.html
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/blog/2017-04-13-hello.json layouts/page.html | $(DETAILS) > $@
# _site/jqt/blog/index.html: content/blog/index.md layouts/blog.html
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/blog/index.json layouts/blog.html | $(DETAILS) > $@

########################################################################
# Standard targets.
########################################################################

.PHONY: clean clobber build

# Copy Assets after create HTML pages.
all:: $(PagesHTML)
	@cp --verbose --recursive --update $(Assets)/* $(Destination) \
	| sed "s/^.*-> ./==> /;s/.$$//"

# Delete secondary files.
clobber:: ; @rm -rf *~ *.bak  *.log

# Build again all documents.
build: clean all

########################################################################
# Debug variations on the `build` target.

.PHONY: dbg.meta dbg.touch dbg.fresh

# Touch top file
define TEST_AND_TOUCH.sh
  if test -e config.yaml;	\
  then touch config.yaml;	\
  elif test -e config.json;	\
  then touch config.json;	\
  else false;			\
  fi
endef

# Force regeneration of all metadata and data files.
dbg.meta:
ifdef MAKE_RESTARTS
	@$(MAKE) -s $(DataFiles) VERBOSE=$(VERBOSE) TRACE=$(TRACE)
else
	@rm -rf $(Metadata)
	@$(MAKE) -s $(DataFiles) VERBOSE=$(VERBOSE) TRACE=$(TRACE)
endif

# Make after touching `config.{yaml,json}`.
dbg.touch:
	@$(TEST_AND_TOUCH.sh)
	@$(MAKE) -s all VERBOSE=$(VERBOSE) TRACE=$(TRACE)

# Clobber and build again.
dbg.fresh: clobber
	@$(MAKE) -s all VERBOSE=$(VERBOSE) TRACE=$(TRACE)

endif # __phase_3

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
