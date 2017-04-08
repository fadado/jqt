########################################################################
# config.make
#
# Build files derived from user defined configuration file.
#
# Imported variables:
#	Metadata
#	Version
# Exported targets:
# 	$(Metadata)
#	$(Metadata)/config.json
#	$(Metadata)/site.json
#	$(Metadata)/globals.make
# Order of dependencies:
# 	config.{yaml,json} => config.json => site.json => globals.make

########################################################################
# Targets for directories
########################################################################

# Create metadata directory.
# Receive all generated metadata files and makefiles.
$(Metadata) $(Metadata)/:
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

########################################################################
# Targets for configuration files
########################################################################

#
# Create `$(Metadata)/config.json`.
#

# Input is user defined `config.yaml` or `config.json`.
ifeq (config.yaml,$(wildcard config.yaml))

# Convert `config.yaml` to `$(Metadata)/config.json`.
$(Metadata)/config.json: config.yaml \
| $(Metadata)
	$(info ==> $@)
	@yaml2json < $< > $@

else ifeq (config.json,$(wildcard config.json))

# Convert `config.json` to `$(Metadata)/config.json`.
$(Metadata)/config.json: config.json \
| $(Metadata)
	$(info ==> $@)
	@jqt -Pjson < $< > $@

else
$(error Configuration file not found)
endif

#
# Create `$(Metadata)/site.json` from `$(Metadata)/config.json`.
#

# Add some new members to `$(Metadata)/config.json` and delete `.defaults`.
define m_SITE_JSON.jq :=
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

#
$(Metadata)/site.json: $(Metadata)/config.json
	$(info ==> $@)
	@jq --sort-keys '$(m_SITE_JSON.jq)' < $< > $@

#
# Create `$(Metadata)/globals.make` from `$(Metadata)/site.json`.
#

# Format members as make variables.
define m_GLOBALS_MAKE.jq :=
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

#
$(Metadata)/globals.make: $(Metadata)/site.json
	$(info ==> $@)
	@jq --raw-output '$(m_GLOBALS_MAKE.jq)' < $< > $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
