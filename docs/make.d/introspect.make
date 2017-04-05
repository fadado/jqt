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
#	...

# Markdown documents found in the filesystem (only .md extensions)
_documents := $(sort $(shell find $(Content) -type f -a -name '*.md'))

# Unique paths to documents directories
_paths := $(sort $(dir $(_documents)))

# Paths to create at $(Destination)
_paths_destination := $(patsubst $(Content)%,$(Destination)%,$(_paths))

# Paths to nodes at $(Metadata)
_paths_meta_nodes := $(patsubst $(Content)%,$(Metadata)/nodes%,$(_paths))

# Paths to pages at $(Metadata)
_paths_meta_pages := $(patsubst $(Content)%,$(Metadata)/pages%,$(_paths))

#
# Make directories
#

$(Destination):
	$(info ==> $@)
	@mkdir $@ >/dev/null 2>&1 || true

$(_paths_destination): $(Destination)/% : $(Content)/%
	@mkdir $@ >/dev/null 2>&1 || true

$(_paths_meta_pages): $(Metadata)/pages/% : $(Content)/%
	@mkdir $@ >/dev/null 2>&1 || true

$(_paths_meta_nodes): $(Metadata)/nodes/% : $(Content)/%
	@mkdir $@ >/dev/null 2>&1 || true

#
# Global names defined
#

# Home page
HomePage := $(Destination)/index.html

# Pages to generate at $(Destination)
Pages := $(patsubst %.md,%.html,$(patsubst $(Content)%,$(Destination)%,$(_documents)))
OtherPages := $(filter-out $(HomePage),$(Pages))

# JSON for each page to generate at $(Metadata)/pages
PagesJSON := $(patsubst %.md,%.json,$(patsubst $(Content)%,$(Metadata)/pages%,$(_documents)))

# Nodes to generate at $(Destination)
NodesHTML := $(call rest,$(patsubst %/,%/index.html,$(_paths_destination))))

# JSON for each node to generate at $(Metadata)/nodes
NodesJSON := $(call rest,$(patsubst %/,%.json,$(_paths_meta_nodes))))

#########################################################################
# Test
intro:
	@echo 'Metadata: $(Metadata)'
	@echo 'Content: $(Content)'
	@echo 'Destination: $(Destination)'
	@echo
	@echo '_documents: $(_documents)'
	@echo '_paths: $(_paths)'
	@echo
	@echo '_paths_meta_nodes: $(_paths_meta_nodes)'
	@echo '_paths_meta_pages: $(_paths_meta_pages)'
	@echo '_paths_destination: $(_paths_destination)'
	@echo
	@echo 'HomePage: $(HomePage)'
	@echo 'Pages: $(Pages)'
	@echo 'OtherPages: $(OtherPages)'
	@echo 'PagesJSON: $(PagesJSON)'
	@echo 'NodesHTML: $(NodesHTML)'
	@echo 'NodesJSON: $(NodesJSON)'

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
