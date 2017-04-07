########################################################################
# Filesystem introspection
########################################################################

# Imported variables:
#	Metadata
#	Content
#	Destination
# Exported variables:
#	HomePage
#	Pages
#	PagesJSON 
#	Nodes
#	NodesJSON
# Exported targets:
# 	$(Destination)
# 	all paths at $(Destination) and $(Metadata)
# Additional dependencies defined:
# 	each HTML page from his metadata and directory
# 	each HTML node from his metadata and directory

# Markdown documents found in the filesystem (only .md extensions)
i_documents := $(sort $(shell find $(Content) -type f -a -name '*.md'))

# Unique paths to documents directories
i_paths := $(sort $(dir $(i_documents)))

# Paths to create at $(Destination)
i_paths_destination := $(call rest,$(patsubst $(Content)%,$(Destination)%,$(i_paths)))

# Paths to nodes at $(Metadata)
i_paths_metadata_nodes := $(patsubst $(Content)%,$(Metadata)/nodes%,$(i_paths))

# Paths to pages at $(Metadata)
i_paths_metadata_pages := $(patsubst $(Content)%,$(Metadata)/pages%,$(i_paths))

########################################################################
# Targets for directories
########################################################################

# Destination directory
$(Destination):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# $(Destination)/.../
$(i_paths_destination):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# $(Metadata)/pages/.../
$(i_paths_metadata_pages):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

# $(Metadata)/nodes/.../
$(i_paths_metadata_nodes):
	$(info ==> $@)
	@mkdir --parents $@ >/dev/null 2>&1 || true

########################################################################
# Exported variables
########################################################################

# Home page
HomePage := $(Destination)/index.html

# Pages to generate at $(Destination)
Pages := $(patsubst %.md,%.html,$(patsubst $(Content)%,$(Destination)%,$(i_documents)))

# JSON for each page to generate at $(Metadata)/pages
PagesJSON := $(patsubst %.md,%.json,$(patsubst $(Content)%,$(Metadata)/pages%,$(i_documents)))

# Nodes to generate at $(Destination)
Nodes := $(addsuffix index.html,$(i_paths_destination))

# JSON for each node to generate at $(Metadata)/nodes
NodesJSON := $(call rest,$(patsubst %/,%.json,$(i_paths_metadata_nodes)))

########################################################################
# Dependencies
########################################################################

# Each HTML file depends on his metadata and directory
$(Pages): $(Destination)/%.html : $(Metadata)/pages/%.json
$(Pages): | $$(dir $$@)

$(Nodes): $(Destination)/%.html : $(Metadata)/nodes/%.json
$(Nodes): | $$(dir $$@)

# Each JSON file depends on his directory
$(PagesJSON): | $$(dir $$@)
$(NodesJSON): | $$(dir $$@)

#########################################################################
# Test
.PHONY: introspect
introspect:
	@echo 'Metadata: $(Metadata)'
	@echo 'Content: $(Content)'
	@echo 'Destination: $(Destination)'
	@echo
	@echo 'i_documents: $(i_documents)'
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
