# jq q JSON == cq q YAML

set -o errexit -o pipefail -o nounset

cd $(dirname $0)

# Conversions
CQ=../bin/cq
J2C=../bin/json2csv

# Same result
diff <(jq -s '.[1]' data/au.json | ${J2C}) \
     <(${CQ} -s '.[1]' data/au.csv)

exit

# vim:ai:sw=4:ts=4:et:syntax=sh
