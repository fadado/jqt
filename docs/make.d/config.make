########################################################################
# config.make
#
# Build files derived from user defined configuration:
# 	config.{yaml,json} => config.json => site.json => phase_1.make
#
# Imported variables:
#	Metadata
#	Version
# Exported rules for:
# 	$(Metadata)
# 	$(Metadata)/
#	$(Metadata)/config.json
#	$(Metadata)/site.json
#	$(Metadata)/phase_1.make

########################################################################
# Metadata directory for all generated metadata and make files
########################################################################

# Define targets with and without trailing slash.
$(Metadata) $(Metadata)/:
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

########################################################################
# Rules for configuration files
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
$(Metadata)/site.json: $(Metadata)/config.json make.d/config.make
	$(info ==> $@)
	@jq --sort-keys				\
	    --from-file make.d/phase0.jq	\
	    --arg Version $(Version)		\
	    < $< > $@

#
# Create `$(Metadata)/phase1.make` from `$(Metadata)/site.json`.
#
$(Metadata)/phase1.make: $(Metadata)/site.json make.d/config.make make.d/phase1.jq
	$(info ==> $@)
	@jq --raw-output 			\
	    --from-file make.d/phase1.jq	\
	    < $< > $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
