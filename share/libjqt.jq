########################################################################
# JQT library
########################################################################

# Produces an integer (ordinal) that is the internal representation of the
# first character in `s`
def ord(s):
    s | explode[0]
;

# Produces a string of length 1 consisting of the character whose internal
# representation is `n`
def chr(n):
    [n] | implode
;

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
