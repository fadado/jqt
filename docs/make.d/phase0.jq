# phase0.jq --arg Version $(Version) --arg Metadata $(Metadata)
# 
# Generate site.json from config.json.

########################################################################
# Output object
########################################################################

# Add some new members if not defined and delete `.defaults`.

del(.defaults)
| . + { 
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
