# phase1.jq
# 
# Generate phase1.make from site.json.

def comment:
    "# vim:syntax=make"
;

########################################################################
# Output makefile
########################################################################

# Format members as make variables.

"__phase_1   := 1",
"Assets      := " + .Assets,
"Blocks      := " + .Blocks,
"Content     := " + .Content,
"Data        := " + .Data,
"Destination := " + .Destination,
"Layouts     := " + .Layouts,
"Styles      := " + .Styles,
comment

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
