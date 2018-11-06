########################################################################
# phase3.jq -- Define contents for `$(Metadata)/phase3.make`.
#
# jq -r -f phase3.jq
#   --arg Metadata $(Metadata)
#   --arg Layouts $(Layouts)
#   --arg Destination $(Destination)
#   < $(Metadata)/pages-by-id.json
#   > $(Metadata)/phase3.make

def dependencies:
    if .Dependencies
    then " " + (.Dependencies | join(" "))
    else "" end
;

def dataset:
    if .Datasets
    then " " + (.Datasets | map("-m\(.):\($Metadata)/\(.).json") | join(" "))
    else "" end
;

def flags:
    if .Flags
    then " " + (.Flags | join(" "))
    else "" end
;

def page:
    " -mpage:\($Metadata)/pages/\(.Id).json"
;

def layout:
    " \($Layouts)/\(.Layout).html"
;

# _site/jqt/index.html: content/index.md layouts/page.html content/macros.m content/LINKS.txt content/EXAMPLE.txt
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/index.json layouts/page.html | $(DETAILS) > $@
# ...
# _site/jqt/blog/2017-04-13-hello.html: content/blog/2017-04-13-hello.md layouts/page.html
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/blog/2017-04-13-hello.json layouts/page.html | $(DETAILS) > $@
def page_rule:
    $Destination+"/"+.URL+": " + .Source + layout + dependencies,
    "\t$(info ==> $@)",
    "\t@$(JQT) -d $<" + dataset + flags + page + layout + " | $(DETAILS) > $@"
;

#
# Output makefile
#

"__phase_3 := 1\n",
(.[] | page_rule), # for each page
"\n# \u0076im:syntax=make"

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
