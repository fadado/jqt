########################################################################
# Metadata
########################################################################

# Imported variables:
#	Metadata

# Metadata directory
$(Metadata):
	$(info ==> $@)
	@mkdir $@ >/dev/null 2>&1 || true

#
# Configuration files
#

# Members to mix with config.yaml when converted to JSON
define JSON_GLOBALS :=
  . + { 						\
  	Destination: (.Destination // "./_site"),	\
  	Assets:      (.Assets      // "./assets"),	\
  	Blocks:      (.Blocks      // "./blocks"),	\
  	Content:     (.Content     // "./content"),	\
  	Data:        (.Data        // "./data"),	\
  	Layouts:     (.Layouts     // "./layouts"),	\
  	Styles:      (.Styles      // "./styles") 	\
  }
endef

# Main configuration file.
# Must be named config.yaml or config.json and must exist.
ifeq (config.yaml, $(wildcard config.yaml))

# Convert config.yaml to $(Metadata)/config.json
$(Metadata)/config.json: config.yaml \
| $(Metadata)
	$(info ==> $@)
	@yaml2json < $< \
	| jq --sort-keys '$(JSON_GLOBALS)' > $@

else ifeq (config.json, $(wildcard config.json))

# Convert config.json to $(Metadata)/config.json
$(Metadata)/config.json: config.json \
| $(Metadata)
	$(info ==> $@)
	@jqt -Pjson < $<	\
	| jq --sort-keys '$(JSON_GLOBALS)' > $@

else
$(error Configuration file not found)
endif

# Variables to define in globals.make
define MAKE_GLOBALS :=
  "# vim:syntax=make",			\
  "",					\
  "__globals__ := 1",			\
  "Destination := " + .Destination,	\
  "Assets      := " + .Assets,		\
  "Blocks      := " + .Blocks,		\
  "Content     := " + .Content,		\
  "Data        := " + .Data,		\
  "Layouts     := " + .Layouts,		\
  "Styles      := " + .Styles,		\
  ""
endef

# Create makefile with globals
$(Metadata)/globals.make: $(Metadata)/config.json
	$(info ==> $@)
	@jq --sort-keys		\
	   --raw-output		\
	   '$(MAKE_GLOBALS)'	\
	   < $< > $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
