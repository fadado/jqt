# Called for each source document, from macro BUILD_PAGE_JSON in created
# phase2.make, to build the JSON file for each page.
#
# input is page front-matter converted to JSON |
# jq -S -f phase2_page.jq 
#   --arg Source $(Content)/.../PAGE.md
#   --arg Target $(Meta)/pages/.../PAGE.json
#   --arg Meta $(Meta)
#   --slurpfile config $(Meta)/config.json
#   > $(Meta)/pages/.../PAGE.json

# Pathname functions
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

# `$(Meta)/pages/path/to/page.json` => `(../)+`
# BUG! No usar Meta en input!!!
def page_base:
    # . as $target
    ("../" * (((. / "/") | length) - 3)) // ""
;

# `$(Meta)/pages/path/to/page.json` => `path/to/page`
def page_id:
    # . as $target
    basename | sub($Meta+"/pages/"; "")
;

# `$(Meta)/pages/path/to/page.json` => `page`
def page_filename:
    # . as $target
    notdir | basename
;

# `$(Meta)/pages/path/to/page.json` => `path/to/`
def page_path:
    # . as $obj
    .Id | dir
;

# `$(Meta)/pages/path/to/page.json` => `path/to`
def page_section:
    #. as $obj
    if $Target | test("(?<!/pages)/index.json$") # index but not home page
    then null
    else .Path[:-1] end
;

# `$(Meta)/pages/path/to/page.json` => `page.html`
def page_slug:
    # . as $obj
    .Filename + ".html"
;

# `$(Meta)/pages/path/to/page.json` => `path/to/page.html`
def page_url:
    # . as $obj
    .Path + .Slug
;

# Extract date if present.
def page_date:
    # . as $obj
    .Filename |
    (capture("^(?<YMD>\\d{4}-\\d{2}-\\d{2})-") | .YMD)
        // ""
;

########################################################################
# Output object for each page
########################################################################

def defaults:
    $Target
    | page_id as $id
    | reduce $config[0].defaults[] as $d
        ({}; if $id | test("^" + $d.idprefix)
             then . + $d.properties
             else . end)
;

def properties:
    $Target
    | {
        Base:     page_base,
        Filename: page_filename,
        Source:   $Source,
        Id:       page_id
    }
    # in the following order!
    | .Path     = page_path
    | .Section  = page_section
    | .Slug     = page_slug
    | .URL      = page_url
    | .Date     = page_date
;

########################################################################
# Generate object to be found in `.page`.
########################################################################

def merge($k; $d; $f):
    if ($k|in($d)) and ($k|in($f))
    then .[$k] = $d[$k] + $f[$k]  # merge list
    else . end
;

. as $f # front_matter
| defaults as $d
| properties as $p
| $d * $f + $p
| merge("Datasets"; $d; $f)
| merge("Dependencies"; $d; $f)
| merge("Flags"; $d; $f)

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
