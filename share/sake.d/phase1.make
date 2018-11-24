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
#	$(Meta)/phase1_site.json
#	$(Meta)/phase1.make

SUPER := $(MDIR)/main.make

########################################################################
# Files derived from user defined configuration file.
########################################################################

#
# Create `$(Meta)/phase1.make` from `$(Meta)/phase1_site.json` using
# `$(MDIR)/phase1.jq`.
#
$(Meta)/phase1.make: $(SUPER) $(THIS) $(CURDIR)/Sakefile 
$(Meta)/phase1.make: $(Meta)/phase1_site.json $(SCRIPT)
	$(info ==> $@)
	jq --raw-output 			\
	   --from-file $(MDIR)/phase1.jq	\
	   < $< > $@

#
# Create `$(Meta)/phase1_site.json` from `$(Meta)/config.json` using
# `$(MDIR)/phase1_site.jq`.
#
$(Meta)/phase1_site.json: $(Meta)/config.json $(SCRIPT) $(THIS)
	$(info ==> $@)
	jq --sort-keys				\
	   --from-file $(MDIR)/phase1_site.jq	\
	   --arg Meta $(Meta)			\
	   < $< > $@

#
# Create `$(Meta)/config.json` from `config.yaml` or `config.json`.
#
ifeq (config.yaml,$(wildcard config.yaml))

# Convert `config.yaml` to `$(Meta)/config.json`.
$(Meta)/config.json: $(CURDIR)/config.yaml $(THIS) \
| $(Meta)
	$(info ==> $@)
	yaml2json < $< > $@

else ifeq (config.json,$(wildcard config.json))

# Convert `config.json` to `$(Meta)/config.json`.
$(Meta)/config.json: $(CURDIR)/config.json $(THIS) \
| $(Meta)
	$(info ==> $@)
	jqt -Pjson < $< > $@

else
$(error Configuration file not found)
endif

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
