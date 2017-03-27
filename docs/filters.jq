#
# Extra filters for this site
#

# Remove XML tags
def striptags:
    # warning: algorithm too simplistic
    gsub("<[^>]*>"; "")
;

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
