########################################################################
# front-matter.conf
#
# Collect metadata from front-matter sections.
#
# Imported variables:
#	Content
#	Metadata
# Exported rules for:
# 	$(Metadata)/pages/.../page.json
# 	$(Metadata)/nodes/.../section.json
# 	$(Metadata)/pages.json
# 	$(Metadata)/nodes.json
# 	$(Metadata)/sections.json

########################################################################
# Collect metadata for pages
########################################################################

# `$(Metadata)/pages/path/to/page.json` => `path/to/page`
define f_page_id =
$(subst $(Metadata)/pages/,$(empty),$(basename $1))
endef

# `$(Metadata)/pages/path/to/page.json` => `(../)+`
define f_page_base =
$(patsubst ../../../%,%,$(subst $(space),$(empty),$(patsubst %,../,$(subst /,$(space),$1))))
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
$(if $(filter %index.json,$1),null,"$(patsubst %/,%,$(call f_page_path,$1))")
endef

# Add members to user defined front-matter at `.`.
#
# Defined by jqt:
#	._content
#	._highlight
#	._toc
#	._source
#	._front_matter
# Defined here (front-matter plus...):
#	.page.base
#	.page.filename
#	.page.id
#	.page.path
#	.page.section
#	.page.source
#	.page.url
#
# Parameters:
#	$1: $(Content)/%.md
#	$2: $(Metadata)/pages/%.json
define f_PAGE_JSON.jq =
  . + {						\
    base:     "$(call f_page_base,$2)",		\
    filename: "$(call f_page_name,$2)",		\
    id:       "$(call f_page_id,$2)",		\
    path:     "$(call f_page_path,$2)",		\
    section:  $(call f_page_section,$2),	\
    source:  "$1",				\
    url:      "$(call f_page_url,$2)"		\
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
$(MetadataPages): $(Metadata)/config.json	
$(MetadataPages): $(Metadata)/pages/%.json : $(Content)/%.md
	$(info ==> $@)
	@$(f_extract_front_matter) < $< 		\
        | yaml2json					\
        | jq --sort-keys				\
             --slurpfile config $(Metadata)/config.json	\
             '$(call f_PAGE_JSON.jq,$<,$@)' > $@

########################################################################
# Group metadata
########################################################################

$(Metadata)/pages.json: $(MetadataPages)
	$(info ==> $@)
	@jq --slurp '.' $^ > $@

$(Metadata)/sections.json: $(Metadata)/pages.json
	$(info ==> $@)
	@jq '[.[].section] | unique | map(select(.))' < $< > $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
