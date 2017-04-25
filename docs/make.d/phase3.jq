# Called from page.make to create auxiliar makefile.
#
# phase3.jq
#   --arg Metadata $(Metadata)
#   --arg Layouts $(Layouts)
#   --arg Destination $(Destination)
#   < $(Metadata)/pages-by-id.json
#   > $(Metadata)/phase3.make

# Function to cheat vim
def comment: "# vim:syntax=make";

def use:
    if .use
    then " " + (.use | join(" "))
    else "" end
;

def data:
    if .data
    then " " + (.data | map("-m\(.):$(Metadata)/snippets.json") | join(" "))
    else "" end
;

def flags:
    if .flags
    then " " + (.flags | join(" "))
    else "" end
;

def page:
    " -mpage:" + $Metadata + "/pages/" + .id + ".json"
;

def layout:
    " " + $Layouts + "/" + .layout + ".html"
;

# makefile rule for HTML page
def page_rule:
    $Destination+"/"+.url+": " + .source + layout + use,
    "\t$(info ==> $@)",
    "\t@$(JQT)  -d $<" + data + flags + page + layout + " | $(DETAILS) > $@"
;

#
# Output makefile
#

"__phase_3 := 1",
(.[] | page_rule), # for each page
comment

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
