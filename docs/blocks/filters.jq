#
# Extra filters for this site
#

import "pages-by-id" as $pages;

# Remove XML tags
def striptags:
    # warning: algorithm too simplistic
    gsub("<[^>]*>"; "")
;

def pages:
    $pages::pages[0]
;

def sections:
    [$pages::pages[0].section]
    | unique
    | map(select(. != null and . != ""))
;

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
