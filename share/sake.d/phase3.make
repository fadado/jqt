########################################################################
# phase3.make -- Define standard rules and rules for HTML pages and nodes.
#
# Rules defined in $(Meta)/phase3.make:
# 	all HTML target files
#
# Rules defined in $(MDIR)/phase3.make:
#	$(Meta)/phase3.make
#	$(Meta)/phase3_json.json
#	$(Meta)/phase3d.make

SUPER := $(Meta)/phase2.make

########################################################################
# Create makefile containing rules for all HTML files.
########################################################################

# Build rules for each page.
$(Meta)/phase3.make: $(SUPER) $(THIS)
$(Meta)/phase3.make: $(Meta)/pages-by-id.json $(SCRIPT)
	$(info ==> $@)
	jq --raw-output					\
	   --arg Meta $(Meta)				\
	   --arg Layouts $(Layouts)			\
	   --arg Root $(Root)				\
	   --from-file $(MDIR)/phase3.jq		\
	   < $< > $@

# Do not preserve!
.INTERMEDIATE: $(Meta)/phase3_json.json

$(Meta)/phase3_json.json: $(SCRIPT) $(THIS)
	$(info ==> $@)
	grep -r '<%include\s\+[^>]\+>'  blocks/ layouts/\
	| sed -e 's/:.*<%include\s\+/\t/;s/>.*$$//'	\
	| jq -nrR					\
	     --arg Layouts $(Layouts)			\
	     --from-file $(MDIR)/phase3_json.jq		\
	     > $@

$(Meta)/phase3d.make: $(Meta)/pages-by-id.json $(Meta)/phase3_json.json $(SCRIPT) $(THIS)
	$(info ==> $@)
	jq --raw-output					\
	   --arg Layouts $(Layouts)			\
	   --arg Root $(Root)				\
	   --slurpfile ldep $(Meta)/phase3_json.json	\
	   --from-file $(MDIR)/phase3d.jq		\
	   < $< > $@

ifdef __phase_3

#
# Variables used in `$(Meta)/phase3.make`.
#

define JQTFLAGS :=
  -msite:$(Meta)/phase1_site.json	\
  -I./					\
  -L$(Meta)				\
  -L$(Blocks)				\
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
# _site/jqt/index.html: content/index.md content/macros.m content/LINKS.txt content/EXAMPLE.txt .meta/snippets.json
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/index.json layouts/page.html | $(DETAILS) > $@
# ...
# _site/jqt/blog/2017-04-13-hello.html: content/blog/2017-04-13-hello.md .meta/snippets.json
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/blog/2017-04-13-hello.json layouts/page.html | $(DETAILS) > $@
# _site/jqt/blog/index.html: content/blog/index.md .meta/snippets.json
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/blog/index.json layouts/blog.html | $(DETAILS) > $@

endif # __phase_3

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
