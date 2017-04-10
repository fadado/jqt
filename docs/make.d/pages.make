########################################################################
# pages.make
#
# Define rules for HTML pages and nodes.
# Define standard rules and rules for HTML pages and nodes.
#
# Imported variables:
#	Assets
#	Destination
#	Layouts
#	Metadata
#	JQTFLAGS
# Exported rules for:
#	$(Metadata)/html.make
#	all:: # assets
# 	build
# 	clean
# 	clobber
# 	xbuild
# 	xxbuild

########################################################################
# Standard targets
########################################################################

.PHONY: clean clobber build xbuild xxbuild

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

xbuild:
	@$(p_test_and_touch.sh)
	@$(MAKE) -s all

# Clobber and build again
xxbuild: clobber
	@$(MAKE) -s all

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

# . is $(Metadata)/pages.json
define p_recipe :=
"\t$$(info ==> $$@)\n\t@$$(JQT) -d $$< $(Layouts)/"+.layout+".html | $$(p_DETAILS) > $$@"
endef

define p_PAGES_D_MAKE.jq :=
  "__html__ := 1",						\
  (.pages[] | (							\
  	"$(Destination)/"+.url+": "+(.use|join(" ")),		\
	"$(Destination)/"+.url+": $(Layouts)/default.html",	\
	"$(Destination)/"+.url+": $(Layouts)/"+.layout+".html",	\
	"$(Destination)/"+.url+": | $$$$(dir $$$$@)",		\
  	"$(Destination)/"+.url+": "+.source+"\n"+$(p_recipe)	\
  )), "# vim:syntax=make"
endef

# Rules for each page (depend also on sections.json only to force build)
$(Metadata)/html.make: $(Metadata)/pages.json $(Metadata)/sections.json
	$(info ==> $@)
	@jq --raw-output '$(p_PAGES_D_MAKE.jq)' < $< > $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
