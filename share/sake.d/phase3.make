########################################################################
# phase3.make -- Define standard rules and rules for HTML pages and nodes.
#
# Rules defined in $(Meta)/phase3.make:
# 	all HTML target files
#
# Rules defined in $(MDIR)/phase3.make:
#	$(Meta)/phase3.make
#
# Targets defined in $(MDIR)/phase3.make:
#	build
# 	clean
# 	clobber
# 	configure

SUPER := $(Meta)/phase2.make

########################################################################
# Create makefile containing rules for all HTML files.
########################################################################

# Build rules for each page.
$(Meta)/phase3.make: $(Meta)/pages-by-id.json $(MDIR)/phase3.jq $(SUPER) $(THIS)
	$(info ==> $@)
	jq --raw-output				\
	   --arg Meta $(Meta)			\
	   --arg Layouts $(Layouts)		\
	   --arg Root $(Root)			\
	   --from-file $(MDIR)/phase3.jq	\
	   < $< > $@

ifdef __phase_3

#
# Variables used in `$(Meta)/phase3.make`.
#

define JQTFLAGS :=
  -msite:$(Meta)/site.json	\
  -I./				\
  -L$(Meta)			\
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

$(PagesHTML): $(Meta)/phase3.make \
| $$(dir $$@)

# Content example for `$(Meta)/phase3.make`:

# __phase_3 := 1
# _site/jqt/index.html: content/index.md layouts/page.html content/macros.m content/LINKS.txt content/EXAMPLE.txt .meta/snippets.json
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/index.json layouts/page.html | $(DETAILS) > $@
# ...
# _site/jqt/blog/2017-04-13-hello.html: content/blog/2017-04-13-hello.md layouts/page.html .meta/snippets.json
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/blog/2017-04-13-hello.json layouts/page.html | $(DETAILS) > $@
# _site/jqt/blog/index.html: content/blog/index.md layouts/blog.html .meta/snippets.json
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/blog/index.json layouts/blog.html | $(DETAILS) > $@

########################################################################
# Standard targets.
########################################################################

.PHONY: clean clobber

# Copy Assets after create HTML pages.
build:: $(PagesHTML)
	@cp --verbose --recursive --update $(Assets)/* $(Root) \
	| sed "s/^.*-> ./==> /;s/.$$//"
	date -Iseconds > $(Meta)/lastbuild

# Delete secondary files.
clobber:: ; @rm -rf *~ *.bak  *.log

########################################################################
# Variations on the `build` target.

.PHONY: configure

# Build all metadata and data files.
configure: $(DataFiles)	# $(PagesJSON) are built for phase2.make

endif # __phase_3

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
