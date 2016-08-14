# cq q YAML == s

set -o errexit -o pipefail -o nounset

cd $(dirname $0)

# Query
CQ=../bin/cq

# Extract string
(( $(${CQ} -J -r 'select(.city == "Hamel").post' data/au.csv) == 6215 ))

exit

# vim:ai:sw=4:ts=4:et:syntax=sh

