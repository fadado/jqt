########################################################################
# tools.make
#
# Miscelaneous tools.
#
# Imported variables:
# 	VNU
#	Root
# Defined targets:
# 	h5.lint
# 	h5.valid

########################################################################
# HTML 5 validation.
########################################################################

# Download vnu.jar from `https://github.com/validator/validator/releases`.

.PHONY: h5.valid h5.lint

# Validation tool.
VNU ?= java -jar /usr/local/vnu/vnu.jar

# Validation.
h5.valid: build
	@xmlwf $(Root)/*.html $(Root)/*/*.html
	@$(VNU) --errors-only --format gnu $(Root)/*.html

# Validation with warnings.
h5.lint: build
	@xmlwf $(Root)/*.html $(Root)/*/*.html
	@$(VNU) --format text $(Root)/*.html

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
