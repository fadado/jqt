#
# Extra filters for this site
#

#import "pages-by-id" as $pages;
#import "phase1_site" as $site;

# Remove XML tags
def striptags:
    # warning: algorithm too simplistic
    gsub("<[^>]*>"; "")
;

#def site: $site::site[0];
#def pages: $pages::pages[0];

#def pages($section):
#  [$pages::pages[0][] | select(.Section=="blog")]
#;

def sections($pages):
    # . as $pages
    map(.section)
    | unique
    | map(select(. != null and . != ""))
;

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
