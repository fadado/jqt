########################################################################
# phase1.make -- Rules for files derived from user defined configuration.
#
# Variables defined in $(Meta)/phase1.make:
#	__phase_1
#	Assets
#	Blocks
#	Content
#	Data
#	Root
#	Layouts
#	Styles
#
# Rules defined in $(MDIR)/phase1.make:
#	$(Meta)/config.json
#	$(Meta)/site.json
#	$(Meta)/phase1.make
# 	$(Root) directory rule and clobber and clean targets

SUPER := $(MDIR)/main.make

########################################################################
# Files derived from user defined configuration file.
########################################################################

#
# Create `$(Meta)/config.json` from `config.yaml` or `config.json`.
#
ifeq (config.yaml,$(wildcard config.yaml))

# Convert `config.yaml` to `$(Meta)/config.json`.
$(Meta)/config.json: $(CURDIR)/config.yaml $(SUPER) $(THIS) \
| $(Meta)
	$(info ==> $@)
	yaml2json < $< > $@

else ifeq (config.json,$(wildcard config.json))

# Convert `config.json` to `$(Meta)/config.json`.
$(Meta)/config.json: $(CURDIR)/onfig.json $(SUPER) $(THIS) \
| $(Meta)
	$(info ==> $@)
	jqt -Pjson < $< > $@

else
$(error Configuration file not found)
endif

#
# Create `$(Meta)/site.json` from `$(Meta)/config.json` using
# `$(MDIR)/phase1_site.jq`.
#
$(Meta)/site.json: $(Meta)/config.json $(MDIR)/phase1_site.jq
	$(info ==> $@)
	jq --sort-keys				\
	   --from-file $(MDIR)/phase1_site.jq	\
	   --arg Meta $(Meta)			\
	   < $< > $@

#
# Create `$(Meta)/phase1.make` from `$(Meta)/site.json` using
# `$(MDIR)/phase1.jq`.
#
$(Meta)/phase1.make: $(Meta)/site.json $(MDIR)/phase1.jq 
	$(info ==> $@)
	jq --raw-output 			\
	   --from-file $(MDIR)/phase1.jq	\
	   < $< > $@

ifdef __phase_1

########################################################################
# Site destination directory.
########################################################################

$(Root):
	$(info ==> $@)
	mkdir --parents $@ >/dev/null 2>&1 || true

# Delete generated files.
clean: ; @rm -rf $(Root)/*

# Delete destination directory.
clobber:: ; @rm -rf $(Root)

endif # __phase_1

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
