# FRONT-MATTER | phase21.jq 
#   --arg Source s
#   --arg Target s
#   --arg Metadata s
#   --slurpfile config s
#   > $(Metadata)/pages/PAGE.json

def basename:
    sub("\\.[^/]+$"; "")
;

def dir:
    if test("/") then sub("/[^/]+$"; "/") else "" end
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
    ("../" * ((($Target / "/") | length) - 3)) // ""
;

# `$(Metadata)/pages/path/to/page.json` => `page`
def page_name:
    $Target | notdir | basename
;

# `$(Metadata)/pages/path/to/page.json` => `path/to/`
def page_path:
    $Target | page_id | dir
;

# `$(Metadata)/pages/path/to/page.json` => `path/to`
def page_section:
    $Target
    | if test("(?<!/pages)/index.json$") # index but not home page
      then null
      else page_path[:-1] end
;

# derived
def page_slug:
    .filename + ".html"
;

def page_date:
    .filename |
    (capture("^(?<YMD>\\d{4}-\\d{2}-\\d{2})-") | .YMD)
        // ""
;

def page_url:
    .path + .slug
;

########################################################################
# Output object for each page
########################################################################

def defaults:
    reduce $config[0].defaults[] as $d
        ({}; if page_id | test("^"+$d.idprefix)
             then . + $d.properties
             else . end)
;

def properties:
    {
        id:       page_id,
        base:     page_base,
        filename: page_name,
        section:  page_section,
        path:     page_path,
        source:   $Source
    }
    | .date = page_date # in this order!
    | .slug = page_slug
    | .url  = page_url
;

. as $front_matter |

# final object 
defaults + properties + $front_matter 

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
