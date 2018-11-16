########################################################################
# phase2.jq -- Define contents for `$(Meta)/phase2.make`.
#
# find $(Content) all MarkDown files |
# jq -s -Rr -f phase2.jq
#   --arg DF "$$(find $(Data) -name '*.*')"
#   --arg Content $(Content)
#   --arg Data $(Data)
#   --arg Root $(Root)
#   --arg Meta $(Meta)
#   > $(Meta)/phase2.make

# Extract pathname directory.
def dir:
    if test("/")
    then sub("/[^/]+$"; "/")
    else "./" end
;

# destination_paths := _site/jqt/ _site/jqt/blog/ ...
def destination_paths($paths):
    def dpath:
        sub("^" + $Content; $Root)
    ;
    "destination_paths := " + ([$paths[] | dpath] | join(" ")) + "\n"
;

# metadata_paths := .meta/pages/ .meta/pages/blog/ ...
def metadata_paths($paths):
    def mpath:
        sub("^" + $Content; $Meta + "/pages")
    ;
    "metadata_paths := " + ([$paths[] | mpath] |  join(" ")) + "\n"
;

# data_md := .meta/snippets.json
# data_yaml :=
# data_json :=
# data_csv :=
def data_files($files):
    def d2m($x):
        sub("\\."+$x+"$"; ".json")
        | sub("^"+$Data; $Meta)
    ;
    ($files / "\n") as $names
    | [$names[] | select(test(".md$"))] as $data_md
    | [$names[] | select(test(".yaml$"))] as $data_yaml
    | [$names[] | select(test(".json$"))] as $data_json
    | [$names[] | select(test(".csv$"))] as $data_csv
    | if ($data_md|length) == 0 then "data_md :=\n"
      else "data_md := " + ($data_md | map(d2m("md")) | join(" ")) + "\n" end
    + if ($data_yaml|length) == 0 then "data_yaml :=\n"
      else "data_yaml := " + ($data_yaml | map(d2m("yaml")) | join(" ")) + "\n" end
    + if ($data_json|length) == 0 then "data_json :=\n"
      else "data_json := " + ($data_json | map(d2m("json")) | join(" ")) + "\n" end
    + if ($data_csv|length) == 0 then "data_csv :=\n"
      else "data_csv := " + ($data_csv | map(d2m("csv")) | join(" ")) + "\n" end
;

# PagesHTML := _site/jqt/content.html _site/jqt/blog/2017-04-13-hello.html ...
def pages_html($documents):
    def dpage:
        sub("^" + $Content; $Root)
        | sub("\\.(?:markdown|mk?d)$"; ".html")
    ;
    "PagesHTML := " + ([$documents[] | dpage] | join(" ")) + "\n"
;

# PagesJSON := .meta/pages/content.json .meta/pages/blog/2017-04-13-hello.json ...
def md2json:
    sub("^" + $Content; $Meta + "/pages")
    | sub("\\.(?:markdown|mk?d)$"; ".json")
;

def pages_json($documents):
    [$documents[] | md2json] as $json
    | "PagesJSON := " + ($json | join(" ")) + "\n"
;

# .meta/pages/content.json: content/content.md
# 	$(info ==> $@)
# 	@$(EXTRACT_FRONT_MATTER) < $< | $(BUILD_PAGE_JSON) > $@
# ...
# .meta/pages/blog/2017-04-13-hello.json: content/blog/2017-04-13-hello.md
# 	$(info ==> $@)
# 	@$(EXTRACT_FRONT_MATTER) < $< | $(BUILD_PAGE_JSON) > $@
def pages_json_rules($documents):
    [ $documents[]
        | md2json + ": " + . + "\n" +
        "\t$(info ==> $@)\n" +
        "\t@$(EXTRACT_FRONT_MATTER) < $< | $(BUILD_PAGE_JSON) > $@"
    ] | join("\n")
;

#
# Output makefile
#
(.[:-1] / "\n") as $documents
| ([$documents[] | dir] | unique) as $paths
|
"__phase_2 := 1\n",
destination_paths($paths),
metadata_paths($paths),
data_files($DF),
pages_html($documents),
pages_json($documents),
pages_json_rules($documents),
"\n# \u0076im:syntax=make"

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
