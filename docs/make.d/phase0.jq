# phase0.jq --arg Version s
# 
# Generate site.json from config.json. Add some new members
# and delete `.defaults`.

del(.defaults)
| . + { 
  	Destination: (.Destination // "./_site"),
  	Assets:      (.Assets      // "./assets"),
  	Blocks:      (.Blocks      // "./blocks"),
  	Content:     (.Content     // "./content"),
  	Data:        (.Data        // "./data"),
  	Layouts:     (.Layouts     // "./layouts"),
  	Styles:      (.Styles      // "./styles"),
  	Version:     (.Version     // $Version)
}

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
