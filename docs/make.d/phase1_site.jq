########################################################################
# phase1_site.jq -- Define global members using default values.
#
# jq -S -f phase1_site.jq --arg Meta $(Meta)
#   < $(Meta)/config.json
#   > $(Meta)/site.json

# Delete `.defaults` and add some new members with default value if not defined
# in the configuration file.
#
del(.defaults)
+ {
  	Meta:       $Meta,
  	Assets:     (.Assets    // "assets"),
  	Blocks:     (.Blocks    // "blocks"),
  	Content:    (.Content   // "content"),
  	Data:       (.Data      // "data"),
  	Root:       (.Root      // "_site"),
  	Layouts:    (.Layouts   // "layouts"),
  	Styles:     (.Styles    // "styles")
}

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
