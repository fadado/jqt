########################################################################
#
#  Specific makefile for this web site
#
# Defined rules for:
#	$(ManPage)
#	/tmp/help
# Defined targets:
# 	all
# 	clean
# 	clobber

########################################################################
# Build pages options
########################################################################

# Declare explicitly modules with -m, -M or -j; this must be decided by a
# human!
JQTFLAGS += -msnippets:$(Metadata)/snippets.json

# Options for `jqt`.
JQTFLAGS += 					\
	-5 					\
	--toc-depth=4				\
	-iblocks/filters			\

# only for derived nodes?
#	-msections:$(Metadata)/sections.json	\

# Extra dependencies
#?$(DestinationPages): $(Blocks)/filters.jq $(Blocks)/*/*.html $(Blocks)/*/*/*.html

########################################################################
# Generate man page for jqt
########################################################################

# gpp for the man page (to be build without calling jqt!)
GPP_MD := gpp						\
	-U '<%' '>' '\B' '\B' '\W>' '<' '>' '$$' ''	\
	-M '<%' '>' '\B' '\B' '\W>' '<' '>'		\
	+sccc '&\n' '' ''				\
	+sccc '\\n' '' ''				\
	+sccc '<\#' '\#>\n' ''				\
	+siqi "'" "'" '\'				\
	+siQi '"' '"' '\'				\
	+ssss '<!--' '-->' ''				\
	+ssss '`'  '`' ''				\
	+ssss '\n```' '\n```' ''			\
	+ssss '\n~~~' '\n~~~' ''			\
    
#
ManPage := ../jqt.1.gz

# Man page: jqt(1)
$(ManPage): $(Content)/jqt.1.text
	$(info ==> $@)
	@$(GPP_MD) -I$(Content) < $<			\
	| pandoc --standalone --from markdown --to man	\
	| gzip > $@

# Add prerequisites and recipes to common targets
all:: $(ManPage)

clean::
	@rm -f $(ManPage)

clobber::
	@rm -f $(ManPage)

########################################################################
# Generate help text
########################################################################

# Independent target: helps generating text for `jqt -h`
# Needs explicit call: `make /tmp/help`
/tmp/help: $(Content)/help.text
	$(info ==> $@)
	@jqt -P MarkDown -I$(Content) < $<				\
	| pandoc --from markdown --to plain -				\
	| sed '1,7b;/^$$/d;s/_\([A-Z]\+\)_/\1/g;/^[^A-Z]/s/^/    /'	\
	> $@

clean::
	@rm -f /tmp/help

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
