########################################################################
# pages.make
#
# Define standard rules and rules for HTML pages and nodes.
#
# Defined rules for:
#	$(Metadata)/phase3.make
# Defined targets:
#	all
# 	build
# 	clean
# 	clobber
# 	fresh
# 	init
# 	touch

########################################################################
# Create makefile containing rules for all HTML files
########################################################################

# Rules for each page (depend also on sections.json only to force build)
$(Metadata)/phase3.make: $(Metadata)/pages.json $(Metadata)/sections.json make.d/pages.make make.d/phase3.jq $(Metadata)/phase2.make
	$(info ==> $@)
	@jq --raw-output			\
	    --arg Metadata $(Metadata)		\
	    --arg Layouts $(Layouts)		\
	    --arg Destination $(Destination)	\
	    --from-file make.d/phase3.jq	\
	    < $< > $@

#
# Variables used in $(Metadata)/phase3.make.
#

JQTFLAGS =					\
	-I./					\
	-msite:$(Metadata)/config.json		\
	-j'$$'pages:$(Metadata)/pages		\

JQT = jqt $(JQTFLAGS)

define DETAILS :=
  sed -e 's/^<p><details><\/p>/<details>/'	\
      -e 's/^<p><\/details><\/p>/<\/details>/'	\
      -e 's/^<p><summary>/<summary>/'		\
      -e 's/<\/summary><\/p>/<\/summary>/'
endef

ifdef __phase_3

########################################################################
# Standard targets
########################################################################

.PHONY: clean clobber build touch fresh

# Copy Assets after create HTML pages
all:: $(DestinationPages) | $(Destination)
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
define TEST_AND_TOUCH.sh
  if test -e config.yaml;	\
  then touch config.yaml;	\
  elif test -e config.json;	\
  then touch config.json;	\
  else false;			\
  fi
endef

touch:
	@$(TEST_AND_TOUCH.sh)
	@$(MAKE) -s all

# Clobber and build again
fresh: clobber
	@$(MAKE) -s all

init:
	@rm -rf $(Metadata)
	@$(MAKE) -s $(Metadata)/phase3.make

endif

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
