########################################################################
# pages.make
#
# Define standard rules and rules for HTML pages and nodes.
#
# Imported variables:
#	Assets
#	Destination
#	Layouts
#	Metadata
#	JQTFLAGS
# Exported rules for:
#	$(Metadata)/phase_3.make
#	all:: # assets
# 	build
# 	clean
# 	clobber
# 	touch
# 	fresh

########################################################################
# Standard targets
########################################################################

.PHONY: clean clobber build touch fresh

# Copy Assets
all:: | $(Destination)
	@cp --verbose --recursive --update $(Assets)/* $(Destination) \
	| sed "s/^.*-> ./==> /;s/.$$//"

# Delete generated files and logs
clean::
	@rm -rf *.log $(Destination)/*

# Delete all generated files and directories
clobber:: clean
	@rm -rf *~ *.bak $(Destination) $(Metadata)

# Build again all documents
build: clean all

# Clobber and build again
define p_test_and_touch.sh
  if test -e config.yaml;	\
  then touch config.yaml;	\
  elif test -e config.json;	\
  then touch config.json;	\
  else false;			\
  fi
endef

touch:
	@$(p_test_and_touch.sh)
	@$(MAKE) -s all

# Clobber and build again
fresh: clobber
	@$(MAKE) -s all

init:
	@rm -rf $(Metadata)
	@$(MAKE) -s $(Metadata)/phase_3.make

########################################################################
# Create makefile containing rules for all HTML files
########################################################################

# Call jqt with user defined flags
JQT = jqt $(JQTFLAGS)

# hack to modify <detail> markup
define p_DETAILS :=
  sed	-e 's/^<p><details><\/p>/<details>/'		\
	-e 's/^<p><\/details><\/p>/<\/details>/'	\
	-e 's/^<p><summary>/<summary>/'			\
	-e 's/<\/summary><\/p>/<\/summary>/'
endef

# Complete command
define p_recipe :=
"\t$$(info ==> $$@)\n\t@$$(JQT) -mpage:$(Metadata)/pages/"+.id+".json -d $$< $(Layouts)/"+.layout+".html | $$(p_DETAILS) > $$@"
endef

define p_layouts :=
$(Layouts)/default.html $(Layouts)/"+.layout+".html | $$$$(dir $$$$@)"
endef

# . is $(Metadata)/pages.json
define PHASE_3.jq :=
  "__phase_3 := 1",						\
  (.[] | (							\
  	"$(Destination)/"+.url+": "+(.use//[]|join(" ")),	\
	"$(Destination)/"+.url+": $(p_layouts),			\
  	"$(Destination)/"+.url+": "+.source+"\n"+$(p_recipe)	\
  )), "# vim:syntax=make"
endef

# Rules for each page (depend also on sections.json only to force build)
$(Metadata)/phase_3.make: $(Metadata)/pages.json $(Metadata)/sections.json
	$(info ==> $@)
	@jq --raw-output '$(PHASE_3.jq)' < $< > $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
