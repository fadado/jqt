########################################################################
# front-matter.conf
#
# Collect metadata from front-matter sections.
#
# Imported variables:
#	Content
#	Metadata
# Exported targets:
# 	$(Metadata)/pages/.../page.json
# 	$(Metadata)/nodes/.../node.json
# 	$(Metadata)/pages.json
# 	$(Metadata)/nodes.json
# 	$(Metadata)/sections.json

########################################################################
# Collect metadata for pages
########################################################################

# `$(Metadata)/pages/path/to/page.json` => `path/to/page`
define f_page_id =
$(subst $(Metadata)/pages/,,$(basename $1))
endef

# `$(Metadata)/pages/path/to/page.json` => `(../)+`
define f_page_base =
$(patsubst ../../%,%,$(subst $(space),$(empty),$(patsubst %,../,$(subst /,$(space),$1))))
endef

# `$(Metadata)/pages/path/to/page.json` => `page`
define f_page_name =
$(basename $(notdir $1))
endef

# `$(Metadata)/pages/path/to/page.json` => `path/to/page.html`
define f_page_url =
$(call f_page_id,$1).html
endef

# `$(Metadata)/pages/path/to/page.json` => `path/to/`
define f_page_path =
$(dir $(call f_page_id,$1))
endef

# `$(Metadata)/pages/path/to/page.json` => `path/to`
define f_page_section =
$(patsubst %/,%,$(call f_page_path,$1))
endef

# `.` is a MarkDown file front matter.
define f_PAGE_JSON.jq =
  . + {						\
    source:   "$1",				\
    id:       "$(call f_page_id,$2)",		\
    base:     "$(call f_page_base,$2)",		\
    filename: "$(call f_page_name,$2)",		\
    path:     "$(call f_page_path,$2)",		\
    url:      "$(call f_page_url,$2)",		\
    section:  "$(call f_page_section,$2)",	\
    isnode:   false,				\
    ispage:   true				\
  } as $$page |					\
  $$config[0].defaults as $$defaults |		\
  reduce $$defaults[] as $$d			\
    ({}; if "$(call f_page_id,$2)" | test("^" + $$d.idprefix) \
         then . + $$d.properties		\
         else . end) + $$page
endef

# Extract YAML front matter.
define f_extract_front_matter =
  sed -n -e '1d'		\
  	 -e '/^---$$/q'		\
	 -e '/^\.\.\.$$/q'	\
	 -e '/^\#/d'		\
	 -e 'p'
endef

# Build metadata for pages.
$(PagesJSON): $(Metadata)/config.json	
$(PagesJSON): $(Metadata)/pages/%.json : $(Content)/%.md
	$(info ==> $@)
	@$(f_extract_front_matter) < $< 		\
        | yaml2json					\
        | jq --sort-keys				\
             --slurpfile config $(Metadata)/config.json	\
             '$(call f_PAGE_JSON.jq,$<,$@)' > $@

########################################################################
# Collect metadata for nodes
########################################################################

define f_node_id =
$(subst $(Metadata)/nodes/,$(empty),$(basename $1))/index
endef

# `.` is `$(Metadata)/config.json`.
define f_NODE_JSON.jq =
  { id:       "$(call f_node_id,$1)",		\
    base:     "$(call f_page_base,$1)",		\
    title:    "$(call f_page_name,$1)",	\
    filename: "$(call f_page_name,$1)",		\
    path:     "$(call f_page_path,$1)",		\
    url:      "$(call f_page_url,$1)",		\
    section:  "$(call f_page_section,$1)",	\
    date:     (now | todateiso8601),		\
    ishome:   false,				\
    isnode:   true,				\
    ispage:   false				\
  } as $$node |					\
  reduce .defaults[] as $$d			\
    ({}; if "$(call f_node_id,$1)" | test("^" + $$d.idprefix) \
         then . + $$d.properties		\
         else . end) + $$node
endef

# Build metadata for nodes
$(NodesJSON): $(Metadata)/config.json	
	$(info ==> $@)
	jq --sort-keys '$(call f_NODE_JSON.jq,$@)' < $< > $@

########################################################################
# Group metadata
########################################################################

$(Metadata)/pages.json: $(PagesJSON)
	$(info ==> $@)
	@jq --slurp '{ pages: . }' $^ > $@

$(Metadata)/sections.json: $(Metadata)/pages.json
	$(info ==> $@)
	@jq '{ sections: ([.pages[].section] | unique) }' < $< > $@

$(Metadata)/nodes.json: $(NodesJSON)
	$(info ==> $@)
	@test -n "$^" && jq --slurp '{ nodes: . }' $^ > $@ || true

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
