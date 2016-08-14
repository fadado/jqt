# data/person.json == (y2j data/person.yaml)

set -o errexit -o pipefail -o nounset

cd $(dirname $0)

# Conversions
Y2J=../bin/yaml2json

# Slurp two files
jq  --sort-keys --slurp --raw-output \
    '.[0] == .[1]' \
    data/person.json \
    <(${Y2J} data/person.yaml) \
| grep -q true

exit

# vim:ai:sw=4:ts=4:et:syntax=sh
