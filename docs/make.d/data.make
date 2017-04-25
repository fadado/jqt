########################################################################
# data.make
#
# Build metadata from filesystem introspection.
#
# Variables defined in phase2.make:
#	__phase_2
#	DataCSV
#	DataJSON
#	DataMD
#	DataYAML
#	DestinationPages
#	DestinationPaths
#	MetadataPages 
#	MetadataPaths
# Defined rules for:
#	$(Metadata)/phase2.make
# 	$(DataFiles)
# 	$(DestinationPaths)
# 	$(Metadata)/pages-by-id.json
# 	$(MetadataPages)
# 	$(MetadataPaths)
# Targets:
# 	init

########################################################################
# Create makefile defining global variables about pathnames and rules to
# generate JSON metadata files for each page.
########################################################################

$(Metadata)/phase2.make: make.d/data.make make.d/phase2.jq $(Metadata)/phase1.make
	$(info ==> $@)
	@find $(Content) -type f -a			\
			 -name '[!_]*.md' -o		\
			 -name '[!_]*.mkd' -o		\
			 -name '[!_]*.markdown'		\
	| jq --raw-input				\
	     --slurp					\
	     --raw-output				\
	     --from-file make.d/phase2.jq		\
	     --arg DF "$$(find $(Data) -name '*.*')"	\
	     --arg Content $(Content)			\
	     --arg Data $(Data)				\
	     --arg Destination $(Destination)		\
	     --arg Metadata $(Metadata)			\
	     > $@

ifdef __phase_2

#
# Variables used when building JSON files in phase2.make.
#

define EXTRACT_FRONT_MATTER =
  sed -n -e '1d'		\
  	 -e '/^---$$/q'		\
	 -e '/^\.\.\.$$/q'	\
	 -e '/^\#/d'		\
	 -e 'p'
endef

define BUILD_JSON
  yaml2json |					\
  jq --sort-keys				\
     --arg Source $<				\
     --arg Target $@				\
     --arg Metadata $(Metadata)			\
     --slurpfile config $(Metadata)/config.json	\
     --from-file make.d/page.jq
endef

########################################################################
# Extra dependencies
########################################################################

$(DestinationPages): $(Destination)/%.html : $(Metadata)/pages/%.json
$(DestinationPages): $(Layouts)/default.html
$(DestinationPages): | $$(dir $$@)

$(MetadataPages): $(Metadata)/config.json
$(MetadataPages): | $$(dir $$@)

########################################################################
# Rules for directories
########################################################################

# Directories starting at `$(Destination)/`
$(DestinationPaths):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# Directories starting at `$(Metadata)/pages/`.
$(MetadataPaths):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

########################################################################
# Group metadata
########################################################################

# Bundle all pages as a relation (id => page)
$(Metadata)/pages-by-id.json: $(MetadataPages)
	$(info ==> $@)
	@jq --slurp 'reduce .[] as $$p ({}; . + {($$p.id): $$p})' $^ > $@

########################################################################
# Files derived from $(Data)/*
########################################################################

ifneq (,$(DataMD))
$(DataMD): $(Metadata)/%.json : $(Data)/%.md | $(Metadata)
	$(info ==> $@)
	@jqt -T < $< | yaml2json > $@
endif

ifneq (,$(DataYAML))
$(DataYAML): $(Metadata)/%.json : $(Data)/%.yaml | $(Metadata)
	$(info ==> $@)
	@yaml2json > $@
endif

ifneq (,$(DataJSON))
$(DataJSON): $(Metadata)/%.json : $(Data)/%.yaml | $(Metadata)
	$(info ==> $@)
	@jqt -P json < $< > $@
endif

ifneq (,$(DataCSV))
$(DataCSV): $(Metadata)/%.json : $(Data)/%.yaml | $(Metadata)
	$(info ==> $@)
	@csv2json < $< > $@
endif

DataFiles := $(DataMD) $(DataYAML) $(DataJSON) $(DataCSV)

########################################################################

$(DestinationPages): $(DataFiles)

# make all metadata and data files
init::
ifdef MAKE_RESTARTS
	@$(MAKE) -s $(DataFiles)
else
	@rm -rf $(Metadata)
	@$(MAKE) -s $(DataFiles)
endif

endif # __phase_2

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
