########################################################################
# Collect metadata in files front-matter
########################################################################

# Imported variables:
#	Metadata
#	Content
# Exported targets:
# 	JSON metadata files for pages and nodes

########################################################################
# Collect metadata for pages
########################################################################

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
define i_PAGE_JSON.jq =
  . + {						\
    id:       "$(call i_page_id,$1)",		\
    base:     "$(call i_page_base,$1)",		\
    filename: "$(call i_page_name,$1)",		\
    path:     "$(call i_page_path,$1)",		\
    url:      "$(call i_page_url,$1)",		\
    section:  "$(call i_page_section,$1)",	\
    isnode:   false,				\
    ispage:   true				\
  } as $$page |					\
  $$config[0].defaults as $$defaults |		\
  reduce $$defaults[] as $$d			\
    ({}; if "$(call i_page_id,$1)" | test("^" + $$d.idprefix) \
         then . + $$d.properties		\
         else . end) + $$page
endef

# Extract YAML front matter
define i_extract_front_matter =
  sed -n -e '1d'		\
  	 -e '/^---$$/q'		\
	 -e '/^\.\.\.$$/q'	\
	 -e '/^\#/d'		\
	 -e 'p'
endef

# Build metadata for pages
$(PagesJSON): $(Metadata)/config.json	
$(PagesJSON): $(Metadata)/pages/%.json : $(Content)/%.md
	$(info ==> $@)
	@$(i_extract_front_matter) < $< 		\
        | yaml2json					\
        | jq --sort-keys				\
             --slurpfile config $(Metadata)/config.json	\
             '$(call i_PAGE_JSON.jq,$@)' > $@

########################################################################
# Collect metadata for nodes
########################################################################

define i_node_id =
$(subst $(Metadata)/nodes/,$(empty),$(basename $1))/index
endef

# . is $(Metadata)/config.json
define i_NODE_JSON.jq =
  { id:       "$(call i_node_id,$1)",		\
    base:     "$(call i_page_base,$1)",		\
    title:    "$(call md_page_name,$1)",	\
    filename: "$(call i_page_name,$1)",		\
    path:     "$(call i_page_path,$1)",		\
    url:      "$(call i_page_url,$1)",		\
    section:  "$(call i_page_section,$1)",	\
    date:     (now | todateiso8601),		\
    ishome:   false,				\
    isnode:   true,				\
    ispage:   false				\
  } as $$node |					\
  reduce .defaults[] as $$d			\
    ({}; if "$(call i_node_id,$1)" | test("^" + $$d.idprefix) \
         then . + $$d.properties		\
         else . end) + $$node
endef

# Build metadata for nodes
$(NodesJSON): $(Metadata)/config.json	
	$(info ==> $@)
	jq --sort-keys '$(call i_NODE_JSON.jq,$@)' < $< > $@

#########################################################################
# Test
.PHONY: front-matter
front-matter:
	@:

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
