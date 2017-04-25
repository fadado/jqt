########################################################################
# config.make
#
# Build files derived from user defined configuration:
# 	config.{yaml,json} => config.json => site.json => phase1.make
#
# Variables defined in phase1.make:
#	__phase_1
#	Assets
#	Blocks
#	Content
#	Data
#	Destination
#	Layouts
#	Styles
# Defined rules for:
# 	$(Metadata)
#	$(Metadata)/config.json
#	$(Metadata)/phase1.make
#	$(Metadata)/site.json

########################################################################
# Metadata directory for all generated make and metadata files
########################################################################

$(Metadata):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

########################################################################
# Files derived from user defined configuration file
########################################################################

#
# Create `$(Metadata)/config.json` from `config.yaml` or `config.json`.
#
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
$(Metadata)/site.json: $(Metadata)/config.json make.d/config.make make.d/site.jq
	$(info ==> $@)
	@jq --sort-keys				\
	    --from-file make.d/site.jq		\
	    --arg Version $(Version)		\
	    --arg Metadata $(Metadata)		\
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
