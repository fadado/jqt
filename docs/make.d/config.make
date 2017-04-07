########################################################################
# Configuration
########################################################################

# Imported variables:
#	Metadata
#	Version
# Exported targets:
# 	$(Metadata)
#	$(Metadata)/config.json
#	$(Metadata)/site.json
#	$(Metadata)/globals.make
# Order of dependencies:
# 	globals.make => site.json => config.json => config.yaml

# Metadata directory
$(Metadata):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

#
# Target files
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
define m_GLOBALS_MAKE :=
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
	@jq --raw-output '$(m_GLOBALS_MAKE)' < $< > $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
