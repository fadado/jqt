########################################################################
# pathnames.make
#
# Build metadata from filesystem introspection.
#
# Imported variables:
#	Content
#	Destination
#	Metadata
# Exported variables:
#	DestinationPages
#	DestinationPaths
#	HomePage
#	MetadataPages 
#	MetadataPaths
# Exported rules for:
# 	$(Destination)
# 	$(Destination)/.../
# 	$(Metadata)/.../
#	all:: $(DestinationPages)
# Additional dependencies defined:
# 	$(Destination)/.../page.html => $(Metadata)/pages/.../page.json

########################################################################
# Derived pathnames
########################################################################

# Markdown documents found in the filesystem (only `.md` extensions).
#i_suffixes := -name '*.md' -o -name '*.mkd' -o -name '*.markdown'
i_suffixes := -name '[!_]*.md' 
i_documents := $(sort $(shell find $(Content) -type f -a $(i_suffixes)))

# Unique paths to documents directories.
i_paths := $(sort $(dir $(i_documents)))

########################################################################
# Exported variables
########################################################################

# Paths to create at `$(Destination)`.
DestinationPaths := $(call rest,$(patsubst $(Content)%,$(Destination)%,$(i_paths)))

# Paths to pages at `$(Metadata)`.
MetadataPaths := $(patsubst $(Content)%,$(Metadata)/pages%,$(i_paths))

# Home page.
HomePage := $(Destination)/index.html

# Pages to generate at `$(Destination)`.
DestinationPages := $(patsubst %.md,%.html,$(patsubst $(Content)%,$(Destination)%,$(i_documents)))

# JSON for each page to generate at `$(Metadata)/pages`.
MetadataPages := $(patsubst %.md,%.json,$(patsubst $(Content)%,$(Metadata)/pages%,$(i_documents)))

########################################################################
# Extra dependencies
########################################################################

# Each HTML file depends on his metadata and directory.
$(DestinationPages): $(Destination)/%.html : $(Metadata)/pages/%.json
$(DestinationPages): | $$(dir $$@)

# Each JSON file depends on his directory.
$(MetadataPages): | $$(dir $$@)

# Add prerequisites to default goal
all:: $(DestinationPages)

########################################################################
# Rules for directories
########################################################################

# Destination directory.
# Define targets with and without trailing slash.
$(Destination) $(Destination)/:
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# Directories starting at `$(Destination)/`
$(DestinationPaths):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# Directories starting at `$(Metadata)/pages/`.
$(MetadataPaths):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

########################################################################
#
########################################################################

# Makefile to be included in `Makefile`.
#!$(Metadata)/phase_2.make: $(Metadata)/phase_1.json make.d/pathnames.make
#!	$(info ==> $@)
#!	@jq --raw-output '$(PHASE_1.jq)' < $< > $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
