# phase21.jq - --arg Source s --arg Target s --arg Metadata s --slurpfile config s
# 
# Generate page.json files

def basename:
    sub("\\.[^/]+$"; "")
;

def dir:
    sub("/[^/]+$"; "/")
;

def notdir:
    sub("^.*/"; "")
;

# `$(Metadata)/pages/path/to/page.json` => `path/to/page`
def page_id:
    $Target | basename | sub($Metadata+"/pages/"; "")
;

# `$(Metadata)/pages/path/to/page.json` => `(../)+`
def page_base:
    #$(patsubst ../../../%,%,$(subst $(space),$(empty),$(patsubst %,../,$(subst /,$(space),$1))))
    ("../" * ((($Target / "/") | length) - 3)) // ""
;

# `$(Metadata)/pages/path/to/page.json` => `page`
def page_name:
    $Target | notdir | basename
;

# `$(Metadata)/pages/path/to/page.json` => `path/to/page.html`
def page_url:
    $Target | page_id+".html"
;

# `$(Metadata)/pages/path/to/page.json` => `path/to/`
def page_path:
    $Target | page_id | dir
;

# `$(Metadata)/pages/path/to/page.json` => `path/to`
def page_section:
    $Target
    | if test("index.json$")
    then null
    else page_path[:-1] end
;

########################################################################
#
########################################################################

. + {
    base:     page_base,
    filename: page_name,
    id:       page_id,
    path:     page_path,
    section:  page_section,
    source:   $Source,
    url:      page_url
} +
reduce $config[0].defaults[] as $defaults
    ({}; if page_id | test("^" + $defaults.idprefix)
         then . + $defaults.properties
         else . end)

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
