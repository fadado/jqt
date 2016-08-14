# yq q YAML == s

set -o errexit -o pipefail -o nounset

cd $(dirname $0)

# Query
YQ=../bin/yq

# Extract string
[[ $(${YQ} -J -r '.store.bicycle.color' data/store.yaml) == 'red' ]]

exit

# vim:ai:sw=4:ts=4:et:syntax=sh
