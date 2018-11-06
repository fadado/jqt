########################################################################
# styles.make -- Generate main CSS stylesheet.
#
# Exported rules for:
#	$(Destination)/styles.css

# Secondary prerequisites.
$(Destination)/styles.css:		\
	$(Blocks)/*/style.css		\
	$(Blocks)/*/*/style.css		\
	$(Styles)/*.css			\
	$(Styles)/*.m 			\
	$(Styles)/milligram/*.css	\

$(Destination)/styles.css: $(Styles)/main.css $(THIS) \
| $(Destination)
	$(info ==> $@)
	@jqt -P CSS-min -I$(Styles) < $< > $@

all:: $(Destination)/styles.css

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
