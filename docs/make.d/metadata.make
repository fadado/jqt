########################################################################
# Metadata
########################################################################

# Imported variables:
#	Metadata

# Metadata directory
$(Metadata):
	$(info ==> $@)
	mkdir $@ >/dev/null 2>&1 || true

# Main configuration file.
# Must be named config.yaml or config.json and must exist.
ifeq (config.yaml, $(wildcard config.yaml))

# Convert config.yaml to $(Metadata)/config.json
$(Metadata)/config.json: config.yaml \
| $(Metadata)
	$(info ==> $@)
	yaml2json < $< > $@

else ifeq (config.json, $(wildcard config.json))

# Convert config.json to $(Metadata)/config.json
$(Metadata)/config.json: config.json \
| $(Metadata)
	$(info ==> $@)
	jqt -Pjson < $< > $@

else
$(error Configuration file not found)
endif

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
