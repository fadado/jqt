########################################################################
# phase1.make -- Rules for files derived from user defined configuration.
#
# Variables defined in $(Metadata)/phase1.make:
#	__phase_1
#	Assets
#	Blocks
#	Content
#	Data
#	Destination
#	Layouts
#	Styles
#
# Rules defined in make.d/phase1.make:
#	$(Metadata)/config.json
#	$(Metadata)/site.json
#	$(Metadata)/phase1.make
# 	$(Destination) directory rule and clobber and clean targets

SUPER := Makefile

########################################################################
# Files derived from user defined configuration file.
########################################################################

#
# Create `$(Metadata)/config.json` from `config.yaml` or `config.json`.
#
ifeq (config.yaml,$(wildcard config.yaml))

# Convert `config.yaml` to `$(Metadata)/config.json`.
$(Metadata)/config.json: config.yaml $(SUPER) $(THIS) \
| $(Metadata)
	$(info ==> $@)
	yaml2json < $< > $@

else ifeq (config.json,$(wildcard config.json))

# Convert `config.json` to `$(Metadata)/config.json`.
$(Metadata)/config.json: config.json $(SUPER) $(THIS) \
| $(Metadata)
	$(info ==> $@)
	jqt -Pjson < $< > $@

else
$(error Configuration file not found)
endif

#
# Create `$(Metadata)/site.json` from `$(Metadata)/config.json` using
# `make.d/phase1_site.jq`.
#
$(Metadata)/site.json: $(Metadata)/config.json make.d/phase1_site.jq
	$(info ==> $@)
	jq --sort-keys				\
	   --from-file make.d/phase1_site.jq	\
	   --arg Metadata $(Metadata)		\
	   < $< > $@

#
# Create `$(Metadata)/phase1.make` from `$(Metadata)/site.json` using
# `make.d/phase1.jq`.
#
$(Metadata)/phase1.make: $(Metadata)/site.json make.d/phase1.jq 
	$(info ==> $@)
	jq --raw-output 		\
	   --from-file make.d/phase1.jq	\
	   < $< > $@

ifdef __phase_1

########################################################################
# Site destination directory.
########################################################################

$(Destination):
	$(info ==> $@)
	mkdir --parents $@ >/dev/null 2>&1 || true

# Delete generated files.
clean: ; @rm -rf $(Destination)/*

# Delete destination directory.
clobber:: ; @rm -rf $(Destination)

endif # __phase_1

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
