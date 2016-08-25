########################################################################
# User defined filters
########################################################################

# `iterate` returns an infinite stream of repeated applications of `f` to `.`:
#       x | iterate(f) = x, x|f, x|f|f...
def iterate(f):
    def R: ., (f | R);
    . | R
;

# Infinite generator (use with 'limit')
def fibonacci:
    {x: -1, y: 1}
    | iterate({x: .y, y: (.x+.y)})
    | (.x+.y)
;

# vim:ai:sw=4:ts=4:et:syntax=jq
