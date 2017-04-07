########################################################################
# Metadata
########################################################################

# Imported variables:
#	Metadata
#	Version
# Exported targets:
# 	$(Metadata)
#	$(Metadata)/config.json
#	$(Metadata)/site.json
#	$(Metadata)/globals.make
#	$(Metadata)/pages/**.json
# Order of dependencies:
# 	globals.make => site.json => config.json => config.yaml

# Metadata directory
$(Metadata):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

#
# Configuration
#

# Create $(Metadata)/config.json
# Input is user defined config.yaml or config.json.
ifeq (config.yaml, $(wildcard config.yaml))

# Convert config.yaml to $(Metadata)/config.json
$(Metadata)/config.json: config.yaml \
| $(Metadata)
	$(info ==> $@)
	@yaml2json < $< > $@

else ifeq (config.json, $(wildcard config.json))

# Convert config.json to $(Metadata)/config.json
$(Metadata)/config.json: config.json \
| $(Metadata)
	$(info ==> $@)
	@jqt -Pjson < $< > $@

else
$(error Configuration file not found)
endif

# Globals definition to mix with config.json
define m_SITE_JSON :=
  del(.defaults)					\
  | . + { 						\
  	Destination: (.Destination // "./_site"),	\
  	Assets:      (.Assets      // "./assets"),	\
  	Blocks:      (.Blocks      // "./blocks"),	\
  	Content:     (.Content     // "./content"),	\
  	Data:        (.Data        // "./data"),	\
  	Layouts:     (.Layouts     // "./layouts"),	\
  	Styles:      (.Styles      // "./styles"),	\
  	Version:     (.Version     // "$(Version)")	\
  }
endef

$(Metadata)/site.json: $(Metadata)/config.json
	$(info ==> $@)
	@jq --sort-keys '$(m_SITE_JSON)' < $< > $@

# Variables to define in globals.make
define m_MAKE_GLOBALS :=
  "__globals__ := 1",				\
  "Assets      := " + .Assets,			\
  "Blocks      := " + .Blocks,			\
  "Content     := " + .Content,			\
  "Data        := " + .Data,			\
  "Destination := " + .Destination,		\
  "Layouts     := " + .Layouts,			\
  "Styles      := " + .Styles,			\
  "# vim:syntax=make"
endef

# Create globals.make
$(Metadata)/globals.make: $(Metadata)/site.json
	$(info ==> $@)
	@jq --raw-output '$(m_MAKE_GLOBALS)' < $< > $@

ifdef __globals__

#md_page_id      = $(subst $(MetaDB)/pages/,,$(basename $1))
#md_page_url     = $(call md_page_id,$1).html
#md_page_name    = $(basename $(notdir $1))
#md_page_path    = $(dir $(call md_page_id,$1))
#md_page_section = $(patsubst %/,%,$(call md_page_path,$1))
#md_page_base    = $(patsubst ../../%,%,$(subst $(space),,$(patsubst %,../,$(subst /, ,$1))))
#
## . is a MarkDown file front matter
#define md_entry_page
#  . + {                                         \
#    "id":       "$(call md_page_id,$1)",        \
#    "base":     "$(call md_page_base,$1)",      \
#    "filename": "$(call md_page_name,$1)",      \
#    "path":     "$(call md_page_path,$1)",      \
#    "url":      "$(call md_page_url,$1)",       \
#    "section":  "$(call md_page_section,$1)",   \
#    "isnode":   false,                          \
#    "ispage":   true                            \
#  } as $$page |                                 \
#  $$config[0].defaults as $$defaults |          \
#  reduce $$defaults[] as $$d                    \
#    ({}; if ("$(call md_page_id,$1)" | test("^" + $$d.idprefix)) \
#         then . + $$d.properties                \
#         else . end) + $$page
#endef

#$(Metadata)/pages/%.json: $(Content)/%.md $(Metadata)config.json | $$(dir $$@)		\
#	$(info ==> $@)
#        sed -n -e '1d;/^---$$/q;/^\.\.\.$$/q;/^\#/d;p' < $<	\
#        | yaml2json                                             \
#        | jq --sort-keys                                        \
#             --slurpfile config $(MetaDB)/config.json           \
#             '$(call md_entry_page,$@)' >$@
#

endif # __globals__

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
