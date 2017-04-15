########################################################################
# pathnames.make
#
# Build metadata from filesystem introspection.
#
# Exported rules for:
#	$(Metadata)/phase2.make

########################################################################
# Create makefile defining global parameters about pathnames
########################################################################

$(Metadata)/phase2.make: make.d/pathnames.make make.d/phase2.jq
	$(info ==> $@)
	@find $(Content) -type f -a			\
			 -name '[!_]*.md' -o		\
			 -name '[!_]*.mkd' -o		\
			 -name '[!_]*.markdown'		\
	| jq --raw-input				\
	     --slurp					\
	     --raw-output				\
	     --from-file make.d/phase2.jq		\
	     --arg Content $(Content)			\
	     --arg Destination $(Destination)		\
	     --arg Metadata $(Metadata)			\
	     > $@

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
