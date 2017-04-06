########################################################################
# Introspection of filesystem and files's front-matter
########################################################################

# Imported variables:
#	Metadata
#	Content
#	Destination
# Exported variables:
#	HomePage
#	Pages
#	OtherPages
#	PagesJSON 
#	Nodes
#	NodesJSON
# Targets for:
# 	$(Destination)
# 	all paths at $(Destination) and $(Metadata)

# Markdown documents found in the filesystem (only .md extensions)
i_documents := $(sort $(shell find $(Content) -type f -a -name '*.md'))

# Unique paths to documents directories
i_paths := $(sort $(dir $(i_documents)))

# Paths to create at $(Destination)
i_paths_destination := $(patsubst $(Content)%,$(Destination)%,$(i_paths))

# Paths to nodes at $(Metadata)
i_paths_meta_nodes := $(patsubst $(Content)%,$(Metadata)/nodes%,$(i_paths))

# Paths to pages at $(Metadata)
i_paths_meta_pages := $(patsubst $(Content)%,$(Metadata)/pages%,$(i_paths))

#
# Make directories
#

$(Destination):
	$(info ==> $@)
	@mkdir -p $@ >/dev/null 2>&1 || true

$(i_paths_destination): $(Destination)/% : $(Content)/%
	@mkdir -p $@ >/dev/null 2>&1 || true

$(i_paths_meta_pages): $(Metadata)/pages/% : $(Content)/%
	@mkdir -p $@ >/dev/null 2>&1 || true

$(i_paths_meta_nodes): $(Metadata)/nodes/% : $(Content)/%
	@mkdir -p $@ >/dev/null 2>&1 || true

#
# Global names defined
#

# Home page
HomePage := $(Destination)/index.html

# Pages to generate at $(Destination)
Pages := $(patsubst %.md,%.html,$(patsubst $(Content)%,$(Destination)%,$(i_documents)))
OtherPages := $(filter-out $(HomePage),$(Pages))

# JSON for each page to generate at $(Metadata)/pages
PagesJSON := $(patsubst %.md,%.json,$(patsubst $(Content)%,$(Metadata)/pages%,$(i_documents)))

# Nodes to generate at $(Destination)
Nodes := $(call rest,$(patsubst %/,%/index.html,$(i_paths_destination)))

# JSON for each node to generate at $(Metadata)/nodes
NodesJSON := $(call rest,$(patsubst %/,%.json,$(i_paths_meta_nodes)))

#########################################################################
# Test
intro:
	@echo 'Metadata: $(Metadata)'
	@echo 'Content: $(Content)'
	@echo 'Destination: $(Destination)'
	@echo
	@echo 'i_documents: $(i_documents)'
	@echo 'i_paths: $(i_paths)'
	@echo
	@echo 'i_paths_meta_nodes: $(i_paths_meta_nodes)'
	@echo 'i_paths_meta_pages: $(i_paths_meta_pages)'
	@echo 'i_paths_destination: $(i_paths_destination)'
	@echo
	@echo 'HomePage: $(HomePage)'
	@echo 'Pages: $(Pages)'
	@echo 'OtherPages: $(OtherPages)'
	@echo 'PagesJSON: $(PagesJSON)'
	@echo 'Nodes: $(Nodes)'
	@echo 'NodesJSON: $(NodesJSON)'

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
