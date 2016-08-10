########################################################################
# Tools
########################################################################

#
# Check required tools
#

ifneq (file,$(shell type -t gpp))
$(error Run 'make setup' to install gpp using dnf)
endif

ifneq (file,$(shell type -t jq))
$(error Run 'make setup' to install jq using dnf)
endif

ifneq (file,$(shell type -t pandoc))
$(error Run 'make setup' to install pandoc using dnf)
endif

#
# Show variable value. Usage: make ?VARNAME
#

?%: .force
	echo -E '$($*)'

.force: # simulate phony target

# vim:ai:sw=8:ts=8:noet:syntax=make
