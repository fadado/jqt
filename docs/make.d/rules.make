########################################################################
# rules.make
#
# Define rules for HTML pages and nodes.
#
# Imported variables:
#	Destination
#	JQTFLAGS
#	Layouts
#	Metadata
# Exported targets:
#	$(Metadata)/html.make

########################################################################
# Create makefile for targets rules
########################################################################

# Call jqt with user defined flags
JQT = jqt $(JQTFLAGS)

# hack to modify <detail> markup
define r_DETAILS :=
  sed	-e 's/^<p><details><\/p>/<details>/'		\
	-e 's/^<p><\/details><\/p>/<\/details>/'	\
	-e 's/^<p><summary>/<summary>/'			\
	-e 's/<\/summary><\/p>/<\/summary>/'
endef

# . is $(Metadata)/pages.json
define f_recipe :=
"\t$$(info ==> $$@)\n\t@$$(JQT) -d $$< $(Layouts)/"+.layout+".html | $$(r_DETAILS) > $$@"
endef
define f_PAGES_D_MAKE.jq :=
  "__html__ := 1",						\
  (.pages[] | (							\
  	"$(Destination)/"+.url+": "+(.use|join(" ")),		\
	"$(Destination)/"+.url+": $(Layouts)/default.html",	\
	"$(Destination)/"+.url+": $(Layouts)/"+.layout+".html",	\
	"$(Destination)/"+.url+": | $$$$(dir $$$$@)",		\
  	"$(Destination)/"+.url+": "+.source+"\n"+$(f_recipe)	\
  )), "# vim:syntax=make"
endef

# Rules for each page (depend also on sections.json only to force build)
$(Metadata)/html.make: $(Metadata)/pages.json $(Metadata)/sections.json
	$(info ==> $@)
	@jq --raw-output '$(f_PAGES_D_MAKE.jq)' < $< > $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
