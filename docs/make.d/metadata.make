########################################################################
# Metadata
########################################################################

# Imported variables:
#	Metadata
#	Version
# Targets for:
# 	$(Metadata)
#	$(Metadata)/config.json	==>
#	$(Metadata)/site.json	==>
#	$(Metadata)/globals.make
# Dependencies:
# 	globals.make => site.json => config.json => config.yaml

# Metadata directory
$(Metadata):
	$(info ==> $@)
	@mkdir -p $@ >/dev/null 2>&1 || true

#
# config.json, site.json and globals.make
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
	@jq --raw-output	\
	   '$(m_MAKE_GLOBALS)'	\
	   < $< > $@

ifdef __globals__

#
# TODO: in this file???
# Metadata files built with globals defined
#

#########################################################################
# Build all metadata files (utility not called automatically)
.PHONY: metadata
metadata:				\
	$(Metadata)/globals.make	\
	$(Metadata)/config.json		\
	$(Metadata)/site.json
	@:

endif # __globals__

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
