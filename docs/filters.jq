#
# Extra filters for this site
#

# Remove XML tags
def striptags:
    # warning: algorithm too simplistic
    gsub("<[^>]*>"; "")
;

# vim:ai:sw=4:ts=4:et:syntax=jq
