#
# Extra filters for this site
#

# Remove XML tags
def striptags:
    # warning: algorithm too simplistic
    gsub("<[^>]*>"; "")
;

def sections:
    # . as $pages
    map(.section)
    | unique
    | map(select(. != null and . != ""))
;

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
