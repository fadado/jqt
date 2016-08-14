# data/hardware.json == (j2y data/hardware.json | y2j)

set -o errexit -o pipefail -o nounset

cd $(dirname $0)

# Conversions
Y2J=../bin/yaml2json
J2Y=../bin/json2yaml

# Slurp two files into variable
jq --null-input --raw-output \
    --slurpfile j1 data/hardware.json \
    --slurpfile j2 <(${J2Y} data/hardware.json | ${Y2J}) \
    '$j1 == $j2' | grep -q true

exit

# vim:ai:sw=4:ts=4:et:syntax=sh

