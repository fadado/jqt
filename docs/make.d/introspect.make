########################################################################
# Introspect filesystem and files's front-matter to build metadata
########################################################################

# Imported variables:
#	Metadata
#	Content
#	Destination
# Exported variables:
#	?

# Destination directory
$(Destination):
	$(info ==> $@)
	@mkdir $@ >/dev/null 2>&1 || true

# Markdown document found in the filesystem (only .md extensions)
_documents := $(shell find $(Content) -type f -a -name '*.md')
# Tree structure of directories
_paths := $(sort $(dir $(_documents)))

# Pages to be generated, and related JSON
define fsys_pages =
  $(patsubst %.md,%.$1,$(patsubst $(Content)%,$2%,$(_documents)))
endef

define fsys_tree =
  $(patsubst $(Content)%,$1%,$(_paths))
endef

# All sections and subsections, removing home page node
define fsys_nodes =
  $(call rest,$(patsubst %/,%$1,$2))
endef

#
PagesHTML := $(call fsys_pages,html,$(Destination))
PagesJSON := $(call fsys_pages,json,$(Metadata)/pages)
fsys_tree_site := $(call fsys_tree,$(Destination))
fsys_tree_page := $(call fsys_tree,$(Metadata)/pages)
fsys_tree_node := $(call fsys_tree,$(Metadata)/nodes)
NodesJSON := $(call fsys_nodes,.json,$(fsys_tree_node))
NodesHTML := $(call fsys_nodes,/index.html,$(fsys_tree_site))

# Make directories
$(fsys_tree_site): $(Destination)/% : $(Content)/%
	@mkdir $@ >/dev/null 2>&1 || true
$(fsys_tree_page): $(Metadata)/pages/% : $(Content)/%
	@mkdir $@ >/dev/null 2>&1 || true
$(fsys_tree_node): $(Metadata)/nodes/% : $(Content)/%
	@mkdir $@ >/dev/null 2>&1 || true

#########################################################################
# Test
intro:
	@echo '_documents: $(_documents)'
	@echo '_paths: $(_paths)'
	@echo 'PagesHTML: $(PagesHTML)'
	@echo 'PagesJSON: $(PagesJSON)'
	@echo 'fsys_tree_site: $(fsys_tree_site)'
	@echo 'fsys_tree_page: $(fsys_tree_page)'
	@echo 'fsys_tree_node: $(fsys_tree_node)'
	@echo 'NodesJSON: $(NodesJSON)'
	@echo 'NodesHTML: $(NodesHTML)'

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
