########################################################################
# pathnames.make
#
# Build metadata from filesystem introspection.
#
# Variables defined in phase2.make:
#	__phase_2
#	DestinationPages
#	DestinationPaths
#	MetadataPages 
#	MetadataPaths
# Defined rules for:
#	$(Metadata)/phase2.make
# 	$(DestinationPaths)
# 	$(MetadataPaths)
# 	$(MetadataPages)
# 	$(Metadata)/pages.json
# 	$(Metadata)/sections.json

########################################################################
# Create makefile defining global variables about pathnames and rules to
# generate JSON metadata files for each page.
########################################################################

$(Metadata)/phase2.make: make.d/pathnames.make make.d/phase2.jq $(Metadata)/phase1.make
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
     --from-file make.d/phase21.jq
endef

########################################################################
# Extra dependencies
########################################################################

$(DestinationPages): $(Destination)/%.html : $(Metadata)/pages/%.json
$(DestinationPages): $(Layouts)/default.html

$(MetadataPages): $(Metadata)/config.json

$(DestinationPages): | $$(dir $$@)
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

$(Metadata)/pages.json: $(MetadataPages)
	$(info ==> $@)
	@jq --slurp '.' $^ > $@

$(Metadata)/sections.json: $(Metadata)/pages.json
	$(info ==> $@)
	@jq '[.[].section] | unique | map(select(.))' < $< > $@

endif # __phase_2

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
