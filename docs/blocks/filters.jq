#
# Extra filters for this site
#

import "collected-front-matter" as $pages;

# Remove XML tags
def striptags:
    # warning: algorithm too simplistic
    gsub("<[^>]*>"; "")
;

def pages:
    $pages::pages[0]
;

def sections:
    [pages[].section] | unique | map(select(.))
;

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
