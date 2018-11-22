########################################################################
# phase3_layout.jq -- Define contents for `$(Meta)/phase3_layout.json`.
#
# jq -nRr -f phase3_layout.jq
#   < ...
#   > $(Meta)/phase3_layout.json

def makedepend:
    def branch($root; $tree):
        def _branch:
            if in($tree)
            then . , ($tree[.][] | _branch)
            else .
            end
        ;
        [$root | _branch][1:] | sort
    ;
    reduce inputs as $line ({}; ($line/"\t") as [$key,$value] | .[$key]+=[$value])
    | . as $tree
    | reduce keys_unsorted[] as $r ({}; .[$r]=branch($r; $tree))
    | . as $dependents
    | $tree | keys[]
    | select(startswith($Layouts+"/"))
    | "\(.): \($dependents[.] | join(" "))" 
;

makedepend

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
