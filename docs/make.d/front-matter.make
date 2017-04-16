########################################################################
# front-matter.conf
#
# Collect metadata from front-matter sections.
#
# Imported variables:
# 	Content
#	Destination
#	DestinationPages
#	DestinationPaths
#	Layouts
#	Metadata
#	MetadataPages
#	MetadataPaths
# Exported rules for:
# 	$(DestinationPaths)
# 	$(Metadata)/pages.json
# 	$(Metadata)/sections.json
# 	$(MetadataPages)
# 	$(MetadataPaths)

########################################################################
# Extra dependencies
########################################################################

# Add prerequisites to default goal
all:: $(DestinationPages)

$(DestinationPages): $(Destination)/%.html : $(Metadata)/pages/%.json
$(DestinationPages): $(Layouts)/default.html

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

$(DestinationPages): | $$(dir $$@)
$(MetadataPages): | $$(dir $$@)

########################################################################
# Group metadata
########################################################################

$(Metadata)/pages.json: $(MetadataPages)
	$(info ==> $@)
	@jq --slurp '.' $^ > $@

$(Metadata)/sections.json: $(Metadata)/pages.json
	$(info ==> $@)
	@jq '[.[].section] | unique | map(select(.))' < $< > $@

########################################################################
# Build metadata for pages.
########################################################################

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

$(MetadataPages): $(Metadata)/config.json	

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
