# data/au.json == (j2c data/au.csv | c2j)

set -o errexit -o pipefail -o nounset

cd $(dirname $0)

# Conversions
C2J=../bin/csv2json
J2C=../bin/json2csv

# Slurp two files into variable
jq --null-input --raw-output \
    --slurpfile j1 data/au.json \
    --slurpfile j2 <(${J2C} data/au.json | ${C2J}) \
    '$j1 == $j2' | grep -q true

exit

# vim:ai:sw=4:ts=4:et:syntax=sh

