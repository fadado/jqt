########################################################################
# styles.make -- Generate main CSS stylesheet.
#
# Exported rules for:
#	$(Root)/styles.css

# Secondary prerequisites.
$(Root)/styles.css:		\
	$(Blocks)/*/style.css		\
	$(Blocks)/*/*/style.css		\
	$(Styles)/*.css			\
	$(Styles)/milligram/*.css	\
	$(Styles)/milligram/*.m		\

$(Root)/styles.css: $(Styles)/main.css $(THIS) \
| $(Root)
	$(info ==> $@)
	jqt -P CSS-min -I$(Styles) < $< > $@

build:: $(Root)/styles.css

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
