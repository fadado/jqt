# phase2.jq --arg Content $(Content) --arg Destination $(Destination) --arg Metadata $(Metadata) --arg DF "$$(find $(Data) -name '*.*')
# 
# Generate phase2.make from `find` output.

def comment:
    "# vim:syntax=make"
;

def dir:
    sub("/[^/]+$"; "/") 
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
    ($files / "\n") as $names
    | [($names[] | select(test(".md$")))] as $DataMD
    | [($names[] | select(test(".yaml$")))] as $DataYAML
    | [($names[] | select(test(".json$")))] as $DataJSON
    | [($names[] | select(test(".csv$")))] as $DataCSV
    | ""
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
