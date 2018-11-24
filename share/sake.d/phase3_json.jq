########################################################################
# phase3_json.jq -- Define contents for `$(Meta)/phase3_json.json`.
#
# output from grep/sed includes |
# jq -nR
#    -f ./phase3_json.jq
#    --arg Layouts $(Layouts)
#   > $(Meta)/phase3_json.json

def branch($root; $tree):
    def _branch:
        if in($tree)
        then . , ($tree[.][] | _branch)
        else .
        end
    ;
    [$root | _branch] | sort
;

reduce inputs as $line
    ({}; ($line/"\t") as [$key,$value] | .[$key]+=[$value])
| . as $tree
| reduce (keys_unsorted[]|select(startswith($Layouts+"/"))) as $r
    ({}; .[$r]=branch($r; $tree))


# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
