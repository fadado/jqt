# phase0.jq
#   --arg Version $(Version)
#   --arg Metadata $(Metadata)
#   < $(Metadata)/config.json > $(Metadata)/site.json

#
# Delete `.defaults` and add some new members if not defined
#
del(.defaults)
+ {
  	Destination: (.Destination // "_site"),
  	Assets:      (.Assets      // "assets"),
  	Blocks:      (.Blocks      // "blocks"),
  	Content:     (.Content     // "content"),
  	Data:        (.Data        // "data"),
  	Layouts:     (.Layouts     // "layouts"),
  	Styles:      (.Styles      // "styles"),
  	Metadata:    (.Metadata    // $Metadata),
  	Version:     (.Version     // $Version)
}

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
