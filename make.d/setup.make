########################################################################
# Setup
########################################################################

#
# Install dependencies
#

# Warning: only `dnf`! Use this rule as template to your own script.
setup:
	@rpm -q --quiet general-purpose-preprocessor || sudo dnf -y install general-purpose-preprocessor
	@rpm -q --quiet jq || sudo dnf -y install jq
	@rpm -q --quiet pandoc || sudo dnf -y install pandoc

# vim:ai:sw=8:ts=8:noet:syntax=make
