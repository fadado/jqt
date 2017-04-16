########################################################################
# styles.make
#
# Generate main CSS stylesheet.
#
# Exported rules for:
#	$(Destination)/styles.css

# Styles
$(Destination)/styles.css:		\
	$(Blocks)/*/style.css		\
	$(Blocks)/*/*/style.css		\
	$(Styles)/*.css			\
	$(Styles)/*.m 			\
	$(Styles)/milligram/*.css	\

$(Destination)/styles.css: $(Styles)/main.css
	$(info ==> $@)
	@jqt -P CSS-min -I$(Styles) < $< > $@

all:: $(Destination)/styles.css | $(Destination)

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
