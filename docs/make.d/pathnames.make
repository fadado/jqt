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
#	HomePage
#	Nodes
#	NodesJSON
#	Pages
#	PagesJSON 
# Exported rules for:
# 	$(Destination)
# 	$(Destination)/.../
# 	$(Metadata)/.../
#	all:: $(Pages)
# Additional dependencies defined:
# 	$(Destination)/.../page.html => $(Metadata)/pages/.../page.json
# 	$(Destination)/.../section/index.html => $(Metadata)/nodes/.../section.json

########################################################################
# Derived pathnames
########################################################################

# Markdown documents found in the filesystem (only `.md` extensions).
#i_suffixes := -name '*.md' -o -name '*.mkd' -o -name '*.markdown'
i_suffixes := -name '*.md' 
i_documents := $(sort $(shell find $(Content) -type f -a $(i_suffixes)))

# Unique paths to documents directories.
i_paths := $(sort $(dir $(i_documents)))

# Paths to create at `$(Destination)`.
i_paths_destination := $(call rest,$(patsubst $(Content)%,$(Destination)%,$(i_paths)))

# Paths to nodes at `$(Metadata)`.
i_paths_metadata_nodes := $(patsubst $(Content)%,$(Metadata)/nodes%,$(i_paths))

# Paths to pages at `$(Metadata)`.
i_paths_metadata_pages := $(patsubst $(Content)%,$(Metadata)/pages%,$(i_paths))

########################################################################
# Rules for directories
########################################################################

# Destination directory.
# Define targets with and without trailing slash.
$(Destination) $(Destination)/:
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# Directories starting at `$(Destination)/`
$(i_paths_destination):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# Directories starting at `$(Metadata)/pages/`.
$(i_paths_metadata_pages):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# Directories starting at `$(Metadata)/nodes/`.
$(i_paths_metadata_nodes):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

########################################################################
# Exported variables
########################################################################

# Home page.
HomePage := $(Destination)/index.html

# Pages to generate at `$(Destination)`.
Pages := $(patsubst %.md,%.html,$(patsubst $(Content)%,$(Destination)%,$(i_documents)))

# JSON for each page to generate at `$(Metadata)/pages`.
PagesJSON := $(patsubst %.md,%.json,$(patsubst $(Content)%,$(Metadata)/pages%,$(i_documents)))

# Nodes to generate at `$(Destination)`.
Nodes := $(addsuffix index.html,$(i_paths_destination))

# JSON for each node to generate at `$(Metadata)/nodes`.
NodesJSON := $(call rest,$(patsubst %/,%.json,$(i_paths_metadata_nodes)))

########################################################################
# Extra dependencies
########################################################################

# Each HTML file depends on his metadata and directory.
$(Pages): $(Destination)/%.html : $(Metadata)/pages/%.json
$(Pages): | $$(dir $$@)

$(Nodes): $(Destination)/%.html : $(Metadata)/nodes/%.json
$(Nodes): | $$(dir $$@)

# Each JSON file depends on his directory.
$(PagesJSON): | $$(dir $$@)
$(NodesJSON): | $$(dir $$@)

# Add prerequisites to default goal
all:: $(Pages)

#########################################################################
# Test
..PHONY: .pathnames
.pathnames:
	@echo 'Metadata: $(Metadata)'
	@echo 'Content: $(Content)'
	@echo 'Destination: $(Destination)'
	@echo
	@echo 'i_documents: $(i_documents)'
	@echo 'i_doc_mkd: $(i_doc_mkd)'
	@echo 'i_doc_markdown: $(i_doc_markdown)'
	@echo 'i_paths: $(i_paths)'
	@echo
	@echo 'i_paths_destination: $(i_paths_destination)'
	@echo 'i_paths_metadata_nodes: $(i_paths_metadata_nodes)'
	@echo 'i_paths_metadata_pages: $(i_paths_metadata_pages)'
	@echo
	@echo 'HomePage: $(HomePage)'
	@echo 'Pages: $(Pages)'
	@echo 'PagesJSON: $(PagesJSON)'
	@echo 'Nodes: $(Nodes)'
	@echo 'NodesJSON: $(NodesJSON)'

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
