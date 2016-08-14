# jq q JSON == yq q YAML

set -o errexit -o pipefail -o nounset

cd $(dirname $0)

# Conversions
J2Y=../bin/json2yaml
YQ=../bin/yq

# Same result
diff <(jq --sort-keys '.store.book[1]' data/store.json | ${J2Y}) \
     <(${YQ} --sort-keys '.store.book[1]' data/store.yaml)

exit

# vim:ai:sw=4:ts=4:et:syntax=sh
