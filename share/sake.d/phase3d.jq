########################################################################
# phase3d.jq -- Define contents for `$(Meta)/phase3d.make`.
#
#?# jq -r -f phase3.jq
#?#   --arg Layouts $(Layouts)
#?#   --arg Root $(Root)
#?#   --slurpfile ldep $(Meta)/phase3_json.json
#?#   < $(Meta)/pages-by-id.json
#?#   > $(Meta)/phase3d.make

#_site/content.html: blocks/body/_toc/markup.html blocks/content/markup.html blocks/footer/markup.html blocks/header/markup.html blocks/license/markup.html blocks/logo/markup.html blocks/menu-bar/markup.html blocks/repository/markup.html blocks/toc/markup.html layouts/default.html layouts/page-toc.html
#_site/data.html: blocks/body/_toc/markup.html blocks/content/markup.html blocks/footer/markup.html blocks/header/markup.html blocks/license/markup.html blocks/logo/markup.html blocks/menu-bar/markup.html blocks/repository/markup.html blocks/toc/markup.html layouts/default.html layouts/page-toc.html
def page_layouts:
    .[]
    | "\($Layouts)/\(.Layout).html" as $l
    | $Root+"/"+.URL+": " + ($ldep[0][$l] | join(" "))
;

#
# Output makefile
#

page_layouts,
"\n# \u0076im:syntax=make"

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
