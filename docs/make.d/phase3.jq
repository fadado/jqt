# phase3.jq --arg Metadata $(Metadata) --arg Layouts $(Layouts) --arg Destination $(Destination)
# 
# Generate phase3.make from pages.json

def comment:
    "# vim:syntax=make"
;

def use:
    if .use
    then " "+(.use | join(" "))
    else "" end
;

def flags:
    if .flags then .flags | join(" ") else "" end
;

def data:
    if .data then .data | map("-m\(.):$(Metadata)/snippets.json") | join(" ") else "" end
;

########################################################################
# Output makefile
########################################################################

"__phase_3 := 1",
(.[] | (
    $Destination+"/"+.url+": "+.source+" "+$Layouts+"/"+.layout+".html"+use,
    "\t$(info ==> $@)",
    "\t@$(JQT) "+data+" "+flags+" -mpage:"+$Metadata+"/pages/"+.id+".json -d $< "+$Layouts+"/"+.layout+".html | $(DETAILS) > $@"
    )
),
comment

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
