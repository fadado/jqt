# data/hardware.json == (j2y data/hardware.json | y2j)

set -o errexit -o pipefail -o nounset

cd $(dirname $0)

# Conversions
Y2J=../bin/yaml2json
J2Y=../bin/json2yaml

# Slurp two files
jq  --slurp --raw-output \
    '.[0] == .[1]' \
    data/hardware.json \
    <(${J2Y} data/hardware.json | ${Y2J}) \
| grep -q true

exit

# vim:ai:sw=4:ts=4:et:syntax=sh
