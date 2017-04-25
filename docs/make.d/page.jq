# Called for each source document, from macro BUILD_JSON in created
# phase2.make, to build the JSON file for each page.
#
# input is page front-matter converted to JSON |
# page.jq 
#   --arg Source $(Content)/.../PAGE.md
#   --arg Target $(Metadata)/pages/.../PAGE.json
#   --arg Metadata $(Metadata)
#   --slurpfile config $(Metadata)/config.json
#   > $(Metadata)/pages/PAGE.json

def basename:
    sub("\\.[^/]+$"; "")
;

def dir:
    if test("/")
    then sub("/[^/]+$"; "/")
    else "" end
;

def notdir:
    sub("^.*/"; "")
;

# `$(Metadata)/pages/path/to/page.json` => `path/to/page`
def page_id:
    # . as $target
    basename | sub($Metadata+"/pages/"; "")
;

# `$(Metadata)/pages/path/to/page.json` => `(../)+`
def page_base:
    # . as $target
    ("../" * (((. / "/") | length) - 3)) // ""
;

# `$(Metadata)/pages/path/to/page.json` => `page`
def page_name:
    # . as $target
    notdir | basename
;

# `$(Metadata)/pages/path/to/page.json` => `path/to/`
def page_path:
    # . as $obj
    .id | dir
;

# `$(Metadata)/pages/path/to/page.json` => `path/to`
def page_section:
    #. as $obj
    if $Target | test("(?<!/pages)/index.json$") # index but not home page
    then null
    else .path[:-1] end
;

# derived
def page_slug:
    # . as $obj
    .filename + ".html"
;

def page_date:
    # . as $obj
    .filename |
    (capture("^(?<YMD>\\d{4}-\\d{2}-\\d{2})-") | .YMD)
        // ""
;

def page_url:
    # . as $obj
    .path + .slug
;

########################################################################
# Output object for each page
########################################################################

def defaults:
    # . as $target
    page_id as $id
    | reduce $config[0].defaults[] as $d
        ({}; if $id | test("^" + $d.idprefix)
             then . + $d.properties
             else . end)
;

def properties:
    # . as $target
    {   id:       page_id,
        base:     page_base,
        filename: page_name,
        source:   $Source
    }
    # in the following order!
    | .path     = page_path
    | .section  = page_section
    | .date     = page_date
    | .slug     = page_slug
    | .url      = page_url
;

. as $front_matter |
$Target | defaults + properties + $front_matter 

#        section  slug
#        ⊢--^-⊣ ⊢--^----⊣
#content/extras/name.html
#        ⊢--------v⊣
#        ⊢--v--⊣ id
#          path

#              path           slug
#        ⊢-------^-----⊣⊢------^--------⊣
#content/extras/indexes/name-example.html
#        ⊢------------------v------⊣
#        ⊢-----v------⊣    id
#         section? or limit to one level?

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
