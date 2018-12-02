########################################################################
# phase3.jq -- Define contents for `$(Meta)/phase3.make`.
#
# jq -r -f phase3.jq
#   --arg Meta $(Meta)
#   --arg Layouts $(Layouts)
#   --arg Root $(Root)
#   < $(Meta)/pages-by-id.json
#   > $(Meta)/phase3.make

def basename:
    sub("\\.[^/]+$"; "")
;

def dependencies:
    if .Dependencies
    then " " + (.Dependencies | join(" "))
    else "" end
    +
    if .Datasets
    then " " + ([.Datasets[] | basename | "\($Meta)/\(.).json"] | join(" "))
    else "" end
;

def dataset:
    if .Datasets
    then " " + ([.Datasets[] | basename | "-m\(.):\($Meta)/\(.).json"] | join(" "))
    else "" end
;

def flags:
    if .Flags
    then " " + (.Flags | join(" "))
    else "" end
;

def page:
    " -jpage:pages/\(.Id).json"
;

# %.html: _site/%.html ;
# blog/%.html: _site/blog/%.html ;
def page_target:
    map(.Path)
    | unique[]
    | "\(.)%.html: \($Root)/\(.)%.html ;"
;

def layout:
    " $(Layouts)/\(.Layout).html"
;

# _site/jqt/index.html: content/index.md layouts/page.html content/macros.m content/LINKS.txt content/EXAMPLE.txt
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/index.json layouts/page.html | $(DETAILS) > $@
# ...
# _site/jqt/blog/2017-04-13-hello.html: content/blog/2017-04-13-hello.md layouts/page.html
# 	$(info ==> $@)
# 	@$(JQT) -d $< -mpage:.meta/pages/blog/2017-04-13-hello.json layouts/page.html | $(DETAILS) > $@
def page_rule:
    .[] |
    "\($Root)/"+.URL+": " + .Source + dependencies,
    "\t$(info ==> $@)",
    "\t$(JQT) -d $<" + dataset + flags + page + layout + " | $(DETAILS) > $@"
;

#
# Output makefile
#

"__phase_3 := 1\n",
page_target, # for each path
"",
page_rule,   # for each page
"",
"# \u0076im:syntax=make"

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
