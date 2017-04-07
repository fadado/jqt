########################################################################
# Introspection of filesystem
########################################################################

# Imported variables:
#	Metadata
#	Content
#	Destination
# Exported variables:
#	HomePage
#	Pages
#	PagesJSON 
#	Nodes
#	NodesJSON
# Exported targets:
# 	$(Destination)
# 	all paths at $(Destination) and $(Metadata)
# Additional dependencies
# 	each page from his metadata
# 	each node from his metadata

# Markdown documents found in the filesystem (only .md extensions)
i_documents := $(sort $(shell find $(Content) -type f -a -name '*.md'))

# Unique paths to documents directories
i_paths := $(sort $(dir $(i_documents)))

# Paths to create at $(Destination)
i_paths_destination := $(call rest,$(patsubst $(Content)%,$(Destination)%,$(i_paths)))

# Paths to nodes at $(Metadata)
i_paths_metadata_nodes := $(patsubst $(Content)%,$(Metadata)/nodes%,$(i_paths))

# Paths to pages at $(Metadata)
i_paths_metadata_pages := $(patsubst $(Content)%,$(Metadata)/pages%,$(i_paths))

#
# Targets for directories
#

# Destination directory
$(Destination):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# $(Destination)/.../
$(i_paths_destination):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# $(Metadata)/pages/.../
$(i_paths_metadata_pages):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# $(Metadata)/nodes/.../
$(i_paths_metadata_nodes):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

#
# Exported variables
#

# Home page
HomePage := $(Destination)/index.html

# Pages to generate at $(Destination)
Pages := $(patsubst %.md,%.html,$(patsubst $(Content)%,$(Destination)%,$(i_documents)))

# JSON for each page to generate at $(Metadata)/pages
PagesJSON := $(patsubst %.md,%.json,$(patsubst $(Content)%,$(Metadata)/pages%,$(i_documents)))

# Nodes to generate at $(Destination)
Nodes := $(addsuffix index.html,$(i_paths_destination))

# JSON for each node to generate at $(Metadata)/nodes
NodesJSON := $(call rest,$(patsubst %/,%.json,$(i_paths_metadata_nodes)))

#
# Pages metadata
#

# $(Metadata)/pages/path/to/page.json ==> path/to/page
define i_page_id =
$(subst $(Metadata)/pages/,,$(basename $1))
endef

# $(Metadata)/pages/path/to/page.json ==> ../+
define i_page_base =
$(patsubst ../../%,%,$(subst $(space),$(empty),$(patsubst %,../,$(subst /,$(space),$1))))
endef

# $(Metadata)/pages/path/to/page.json ==> page
define i_page_name =
$(basename $(notdir $1))
endef

# $(Metadata)/pages/path/to/page.json ==> path/to/page.html
define i_page_url =
$(call i_page_id,$1).html
endef

# $(Metadata)/pages/path/to/page.json ==> path/to/
define i_page_path =
$(dir $(call i_page_id,$1))
endef

# $(Metadata)/pages/path/to/page.json ==> path/to
define i_page_section =
$(patsubst %/,%,$(call i_page_path,$1))
endef

# . is a MarkDown file front matter
define i_PAGE_JSON =
  . + {						\
    "id":       "$(call i_page_id,$1)",		\
    "base":     "$(call i_page_base,$1)",	\
    "filename": "$(call i_page_name,$1)",	\
    "path":     "$(call i_page_path,$1)",	\
    "url":      "$(call i_page_url,$1)",	\
    "section":  "$(call i_page_section,$1)",	\
    "isnode":   false,				\
    "ispage":   true				\
  } as $$page |					\
  $$config[0].defaults as $$defaults |		\
  reduce $$defaults[] as $$d			\
    ({}; if "$(call i_page_id,$1)" | test("^" + $$d.idprefix) \
         then . + $$d.properties		\
         else . end) + $$page
endef

# Extract YAML front matter
define i_extract_front_matter
  sed -n -e '1d'		\
  	 -e '/^---$$/q'		\
	 -e '/^\.\.\.$$/q'	\
	 -e '/^\#/d'		\
	 -e 'p'
endef

# Build metadata for a page
$(PagesJSON): $(Metadata)/pages/%.json : $(Content)/%.md \
| $$(dir $$@)
	$(info ==> $@)
	@$(i_extract_front_matter) < $< 		\
        | yaml2json					\
        | jq --sort-keys				\
             --slurpfile config $(Metadata)/config.json	\
             '$(call i_PAGE_JSON,$@)' > $@

# Each page depend on his metadata
$(Pages): $(Destination)/%.html : $(Metadata)/pages/%.json

# Each node depend on his metadata
#$(Nodes): $(Destination)/%.html : $(Metadata)/nodes/%.json

#########################################################################
# Test
.PHONY: intro
intro:
	@echo 'Metadata: $(Metadata)'
	@echo 'Content: $(Content)'
	@echo 'Destination: $(Destination)'
	@echo
	@echo 'i_documents: $(i_documents)'
	@echo 'i_paths: $(i_paths)'
	@echo
	@echo 'i_paths_destination: $(i_paths_destination)'
	@echo 'i_paths_metadata_nodes: $(i_paths_metadata_nodes)'
	@echo 'i_paths_metadata_pages: $(i_paths_metadata_pages)'
	@echo
	@echo 'HomePage: $(HomePage)'
	@echo 'Pages: $(Pages)'
	@echo 'PagesJSON: $(PagesJSON)'
	@echo 'Nodes: $(Nodes)'
	@echo 'NodesJSON: $(NodesJSON)'

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
