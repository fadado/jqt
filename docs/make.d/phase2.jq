# phase2.jq --arg ...
# 
# Generate phase2.make from `find` output.

def comment:
    "# vim:syntax=make"
;

def dir:
    if test("/") then sub("/[^/]+$"; "/") else "./" end
;

def dpaths($paths):
    def dpath:
        sub("^" + $Content; $Destination)
    ;
    "DestinationPaths := " + ([$paths[] | dpath] | join(" "))
;

def mpaths($paths):
    def mpath:
        sub("^" + $Content; $Metadata + "/pages")
    ;
    "MetadataPaths := " + ([$paths[] | mpath] |  join(" "))
;

def dpages($documents):
    def dpage:
        sub("^" + $Content; $Destination)
        | sub("\\.(?:markdown|mk?d)$"; ".html")
    ;
    "DestinationPages := " + ([$documents[] | dpage] | join(" "))
;

def mpages($documents):
    def mpage:
        sub("^" + $Content; $Metadata + "/pages")
        | sub("\\.(?:markdown|mk?d)$"; ".json")
    ;
    def mrule:
        [ $documents[]
          | mpage + ": " + . + "\n" +
          "\t$(info ==> $@)\n" +
          "\t@$(EXTRACT_FRONT_MATTER) < $< | $(BUILD_JSON) > $@"
        ] | join("\n")
    ;
    [$documents[] | mpage] as $json
    | "MetadataPages := " + ($json | join(" ")) + "\n" + mrule
;


def data($files):
    def d2m($x):
        sub("\\."+$x+"$"; ".json")
        | sub("^"+$Data; $Metadata)
    ;
    ($files / "\n") as $names
    | [$names[] | select(test(".md$"))] as $DataMD
    | [$names[] | select(test(".yaml$"))] as $DataYAML
    | [$names[] | select(test(".json$"))] as $DataJSON
    | [$names[] | select(test(".csv$"))] as $DataCSV
    | if ($DataMD|length) == 0 then "DataMD :=\n"
      else "DataMD := " + ($DataMD | map(d2m("md")) | join(" ")) + "\n" end
    + if ($DataYAML|length) == 0 then "DataYAML :=\n"
      else "DataYAML := " + ($DataYAML | map(d2m("yaml")) | join(" ")) + "\n" end
    + if ($DataJSON|length) == 0 then "DataJSON :=\n"
      else "DataJSON := " + ($DataJSON | map(d2m("json")) | join(" ")) + "\n" end
    + if ($DataCSV|length) == 0 then "DataCSV :=\n"
      else "DataCSV := " + ($DataCSV | map(d2m("csv")) | join(" ")) + "\n" end
;

########################################################################
# Output makefile
########################################################################

(.[:-1] / "\n") as $documents
| [$documents[] | dir] | unique as $paths
| dpaths($paths) as $DestinationPaths 
| mpaths($paths) as $MetadataPaths
| dpages($documents) as $DestinationPages 
| mpages($documents) as $MetadataPages
| data($DF) as $DataFiles
|
"__phase_2 := 1",
$DestinationPaths,
$MetadataPaths,
$DestinationPages,
$MetadataPages,
$DataFiles,
comment

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
