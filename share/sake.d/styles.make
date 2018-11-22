########################################################################
# styles.make -- Generate main CSS stylesheet.
#
# Exported rules for:
#	$(Root)/styles.css

# JQTLIB defined in `sake` script.

# Secondary prerequisites.
$(Root)/styles.css:			\
	$(JQTLIB)/milligram/*.css	\
	$(JQTLIB)/milligram/*.m		\
	$(Styles)/*.css			\
	$(Blocks)/*/style.css		\
	$(Blocks)/*/*/style.css		\

$(Root)/styles.css: $(Styles)/main.css $(THIS) \
| $(Root)
	$(info ==> $@)
	jqt -P CSS-min -I$(JQTLIB) -I$(Styles) < $< > $@

build:: $(Root)/styles.css

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
