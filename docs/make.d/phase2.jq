# phase2.jq --arg Destination s -arg Content s --arg Metadata s
# 
# Generate phase2.make from `find` output.

def comment:
    "# vim:syntax=make"
;

def dir:
    sub("/[^/]+$"; "/") 
;

def dpaths($p):
    def dpath:
        sub("^"+$Content; $Destination)
    ;
    "DestinationPaths := " + ([$p[] | dpath][1:] | join(" "))
;

def mpaths($p):
    def mpath:
        sub("^"+$Content; $Metadata+"/pages")
    ;
    "MetadataPaths := " + ([$p[] | mpath] |  join(" "))
;

def dpages($d):
    def dpage:
        sub("^"+$Content; $Destination)
        | sub("\\.(?:markdown|mk?d)$"; ".html")
    ;
    "DestinationPages := " + ([$d[] | dpage] | join(" "))
;

def mpages($d):
    def mpage:
        sub("^"+$Content; $Metadata+"/pages")
        | sub("\\.(?:markdown|mk?d)$"; ".json")
    ;
    [$d[] | mpage] as $json
    | "MetadataPages := " + ($json | join(" ")) #+ "\n"
    #+ ([$json[] | . + ": | $$(dir $$@)"] | join("\n"))
;

########################################################################

(.[:-1]/"\n") as $documents
| [$documents[] | dir] | unique as $paths
| dpaths($paths) as $DestinationPaths 
| mpaths($paths) as $MetadataPaths
| dpages($documents) as $DestinationPages 
| mpages($documents) as $MetadataPages
|
"__phase_2 := 1",
$DestinationPaths,
$MetadataPaths,
$DestinationPages,
$MetadataPages,
comment

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
