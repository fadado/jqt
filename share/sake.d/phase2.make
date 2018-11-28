########################################################################
# phase2.make -- Build metadata from filesystem introspection.
#
# Variables defined in $(Meta)/phase2.make:
#	__phase_2
#	data_csv
#	data_json
#	data_md
#	data_yaml
#	destination_paths
#	metadata_paths
#	PagesHTML
#	PagesJSON 
#
# Rules defined in $(Meta)/phase2.make:
# 	metadata JSON files for each HTML page
#
# Variables defined in $(MDIR)/phase2.make:
#	DataFiles
#
# Rules defined in $(MDIR)/phase2.make:
#	$(data_csv)
#	$(data_json)
#	$(data_md)
#	$(data_yaml)
# 	$(destination_paths)
# 	$(metadata_paths)
#	$(Meta)/content.text
#	$(Meta)/data.text
#	$(Meta)/phase2.make
# 	$(Meta)/pages-by-id.json

SUPER := $(Meta)/phase1.make

########################################################################
# Create makefile defining global variables about pathnames and rules to
# generate JSON metadata files for each page.
########################################################################

#
# Create `$(Meta)/phase2.make` from `find` output using `$(MDIR)/phase2.jq`.
#
$(Meta)/phase2.make: $(SUPER) $(THIS)
$(Meta)/phase2.make: $(Meta)/content.text $(Meta)/data.text $(SCRIPT)
	$(info ==> $@)
	jq --raw-input				\
	   --raw-output				\
	   --slurp				\
	   --from-file $(MDIR)/phase2.jq	\
	   --arg DF "$$(<$(Meta)/data.text )"	\
	   --arg Content $(Content)		\
	   --arg Data $(Data)			\
	   --arg Root $(Root)			\
	   --arg Meta $(Meta)			\
	   < $< > $@

# Do not preserve!
.INTERMEDIATE: $(Meta)/content.text $(Meta)/data.text

$(Meta)/content.text: $(THIS)
	$(info ==> $@)
	find $(Content) -type f -a	\
		-name '[!_]*.md' -o	\
		-name '[!_]*.mkd' -o	\
		-name '[!_]*.markdown'	\
	> $@

$(Meta)/data.text: $(THIS)
	$(info ==> $@)
	find $(Data) -name '*.*' > $@

ifdef __phase_2

#
# Variables used when building JSON files in `$(Meta)/phase2.make`.
#

define EXTRACT_FRONT_MATTER =
  sed -n -e '1d'		\
  	 -e '/^---$$/q'		\
	 -e '/^\.\.\.$$/q'	\
	 -e '/^\#/d'		\
	 -e 'p'
endef

define BUILD_PAGE_JSON
  yaml2json |					\
  jq --sort-keys				\
     --arg Source $<				\
     --arg Target $@				\
     --arg Meta $(Meta)				\
     --slurpfile config $(Meta)/config.json	\
     --from-file $(MDIR)/phase2_page.jq
endef

#
# Extra prerequisites for JSON metadata pages.
#

$(PagesJSON): $(Meta)/config.json $(MDIR)/phase2_page.jq $(THIS) \
| $$(dir $$@)

# Content example for `$(Meta)/phase2.make`:

# __phase_2 := 1
# 
# destination_paths := _site/ _site/blog/
# metadata_paths := .meta/pages/ .meta/pages/blog/
# 
# data_md := .meta/snippets.json
# data_yaml :=
# data_json :=
# data_csv :=
# 
# PagesHTML := _site/content.html _site/data.html _site/index.html _site/engine.html _site/structure.html _site/blog/2017-04-13-hello.html _site/blog/index.html
# PagesJSON := .meta/pages/content.json .meta/pages/data.json .meta/pages/index.json .meta/pages/engine.json .meta/pages/structure.json .meta/pages/blog/2017-04-13-hello.json .meta/pages/blog/index.json
# 
# .meta/pages/content.json: content/content.md
# 	$(info ==> $@)
# 	@$(EXTRACT_FRONT_MATTER) < $< | $(BUILD_PAGE_JSON) > $@
# ...
# .meta/pages/blog/2017-04-13-hello.json: content/blog/2017-04-13-hello.md
# 	$(info ==> $@)
# 	@$(EXTRACT_FRONT_MATTER) < $< | $(BUILD_PAGE_JSON) > $@
# .meta/pages/blog/index.json: content/blog/index.md
# 	$(info ==> $@)
# 	@$(EXTRACT_FRONT_MATTER) < $< | $(BUILD_PAGE_JSON) > $@

########################################################################
# Rules for directories.
########################################################################

# Directories starting at `$(Root)/`.
$(destination_paths):
	$(info ==> $@)
	mkdir --parents $@ >/dev/null 2>&1 || true

# Directories starting at `$(Meta)/pages/`.
$(metadata_paths):
	$(info ==> $@)
	mkdir --parents $@ >/dev/null 2>&1 || true

########################################################################
# Group metadata.
########################################################################

# Bundle all pages as a relation (Id => page)
# TODO: use xargs? write $^ to a temp file with file()?
$(Meta)/pages-by-id.json: $(PagesJSON)
	$(info ==> $@)
	cat $^ 							\
	| jq -n 'reduce inputs as $$p ({}; . + {($$p.Id):$$p})'	\
	> $@

########################################################################
# Files derived from `$(Data)/*`.
########################################################################

DataFiles := 

ifneq (,$(data_md))
$(data_md): $(Meta)/%.json : $(Data)/%.md \
| $(Meta)
	$(info ==> $@)
	jqt -T < $< | yaml2json > $@
DataFiles += $(data_md)
endif

ifneq (,$(data_yaml))
$(data_yaml): $(Meta)/%.json : $(Data)/%.yaml \
| $(Meta)
	$(info ==> $@)
	yaml2json > $@
DataFiles += $(data_yaml)
endif

ifneq (,$(data_json))
$(data_json): $(Meta)/%.json : $(Data)/%.json \
| $(Meta)
	$(info ==> $@)
	jqt -P json < $< > $@
DataFiles += $(data_json)
endif

ifneq (,$(data_csv))
$(data_csv): $(Meta)/%.json : $(Data)/%.csv \
| $(Meta)
	$(info ==> $@)
	csv2json < $< > $@
DataFiles += $(data_csv)
endif

endif # __phase_2

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
