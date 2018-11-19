########################################################################
# styles.make -- Generate main CSS stylesheet.
#
# Exported rules for:
#	$(Root)/styles.css

# DATADIR defined in `sake` script.
_sake := $(DATADIR)/jqt/sake

# Secondary prerequisites.
$(Root)/styles.css:			\
	$(_sake)/milligram/*.css	\
	$(_sake)/milligram/*.m		\
	$(Styles)/*.css			\
	$(Blocks)/*/style.css		\
	$(Blocks)/*/*/style.css		\

$(Root)/styles.css: $(Styles)/main.css $(THIS) \
| $(Root)
	$(info ==> $@)
	jqt -P CSS-min -I$(_sake) -I$(Styles) < $< > $@

build:: $(Root)/styles.css

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
