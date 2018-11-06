########################################################################
# phase2.make -- Build metadata from filesystem introspection.
#
# Variables defined in $(Metadata)/phase2.make:
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
# Rules defined in $(Metadata)/phase2.make:
# 	metadata JSON files for each HTML page
#
# Variables defined in make.d/phase2.make:
#	DataFiles
#
# Rules defined in make.d/phase2.make:
#	$(data_csv)
#	$(data_json)
#	$(data_md)
#	$(data_yaml)
# 	$(destination_paths)
# 	$(metadata_paths)
#	$(Metadata)/content.text
#	$(Metadata)/data.text
#	$(Metadata)/phase2.make
# 	$(Metadata)/pages-by-id.json

SUPER := $(Metadata)/phase1.make

########################################################################
# Create makefile defining global variables about pathnames and rules to
# generate JSON metadata files for each page.
########################################################################

$(Metadata)/content.text: $(THIS)
	$(info ==> $@)
	find $(Content) -type f -a	\
		-name '[!_]*.md' -o	\
		-name '[!_]*.mkd' -o	\
		-name '[!_]*.markdown'	\
	> $@

$(Metadata)/data.text: $(THIS)
	$(info ==> $@)
	find $(Data) -name '*.*' > $@

#
# Create `$(Metadata)/phase2.make` from `find` output using `make.d/phase2.jq`.
#
$(Metadata)/phase2.make: CONTENT := $(Metadata)/content.text 
$(Metadata)/phase2.make: DATA := $(Metadata)/data.text 
$(Metadata)/phase2.make: make.d/phase2.jq $(Metadata)/content.text $(Metadata)/data.text $(SUPER) $(THIS)
	$(info ==> $@)
	jq --raw-input				\
	   --raw-output				\
	   --slurp				\
	   --from-file make.d/phase2.jq		\
	   --arg DF "$$(<$(DATA))"		\
	   --arg Content $(Content)		\
	   --arg Data $(Data)			\
	   --arg Destination $(Destination)	\
	   --arg Metadata $(Metadata)		\
	   < $(CONTENT) > $@

ifdef __phase_2

#
# Variables used when building JSON files in `$(Metadata)/phase2.make`.
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
     --arg Metadata $(Metadata)			\
     --slurpfile config $(Metadata)/config.json	\
     --from-file make.d/phase2_page.jq
endef

#
# Extra prerequisites for JSON metadata pages.
#

$(PagesJSON): $(Metadata)/config.json make.d/phase2_page.jq $(THIS) \
| $$(dir $$@)

# Content example for `$(Metadata)/phase2.make`:

# __phase_2 := 1
# destination_paths := _site/jqt/ _site/jqt/blog/
# metadata_paths := .meta/pages/ .meta/pages/blog/
# data_md := .meta/snippets.json
# data_yaml :=
# data_json :=
# data_csv :=
# PagesHTML := _site/jqt/content.html _site/jqt/blog/2017-04-13-hello.html _site/jqt/blog/index.html
# PagesJSON := .meta/pages/content.json .meta/pages/blog/2017-04-13-hello.json .meta/pages/blog/index.json
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

# Directories starting at `$(Destination)/`.
$(destination_paths):
	$(info ==> $@)
	mkdir --parents $@ >/dev/null 2>&1 || true

# Directories starting at `$(Metadata)/pages/`.
$(metadata_paths):
	$(info ==> $@)
	mkdir --parents $@ >/dev/null 2>&1 || true

########################################################################
# Group metadata.
########################################################################

# Bundle all pages as a relation (Id => page)
# TODO: use xargs? write $^ to a temp file with file()?
$(Metadata)/pages-by-id.json: $(PagesJSON)
	$(info ==> $@)
	cat $^ 							\
	| jq -n 'reduce inputs as $$p ({}; . + {($$p.Id):$$p})'	\
	> $@

#$(Metadata)/pages-by-id.json: $(PagesJSON)
#	$(info ==> $@)
#	@jq --slurp 'reduce .[] as $$p ({}; . + {($$p.Id): $$p})' $^ > $@

########################################################################
# Files derived from `$(Data)/*`.
########################################################################

DataFiles := 

ifneq (,$(data_md))
$(data_md): $(Metadata)/%.json : $(Data)/%.md \
| $(Metadata)
	$(info ==> $@)
	jqt -T < $< | yaml2json > $@
DataFiles += $(data_md)
endif

ifneq (,$(data_yaml))
$(data_yaml): $(Metadata)/%.json : $(Data)/%.yaml \
| $(Metadata)
	$(info ==> $@)
	yaml2json > $@
DataFiles += $(data_yaml)
endif

ifneq (,$(data_json))
$(data_json): $(Metadata)/%.json : $(Data)/%.json \
| $(Metadata)
	$(info ==> $@)
	jqt -P json < $< > $@
DataFiles += $(data_json)
endif

ifneq (,$(data_csv))
$(data_csv): $(Metadata)/%.json : $(Data)/%.csv \
| $(Metadata)
	$(info ==> $@)
	csv2json < $< > $@
DataFiles += $(data_csv)
endif

endif # __phase_2

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
