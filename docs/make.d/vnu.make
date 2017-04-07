# HTML 5 validation

# Imported variables:
#	Destination
# Exported targets:
# 	valid
# 	lint

.PHONY: valid lint

VNU := /usr/local/vnu/vnu.jar

# Validation using vnu.jar
valid: all
	@xmlwf $(Destination)/*.html
	@java -jar $(VNU) --errors-only --format gnu $(Destination)/*.html

# Validation with warnings using vnu.jar
lint: all
	@xmlwf $(Destination)/*.html
	@java -jar $(VNU) --format text $(Destination)/*.html

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
