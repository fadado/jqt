########################################################################
# phase1.jq -- Define contents for `$(Meta)/phase2.make`.
#
# jq -r -f phase1.jq
#   < $(Meta)/site.json
#   > $(Meta)/phase1.make

#
# Output makefile
#
"__phase_1   := 1\n",
"Assets      := " + .Assets,
"Blocks      := " + .Blocks,
"Content     := " + .Content,
"Data        := " + .Data,
"Root        := " + .Root,
"Layouts     := " + .Layouts,
"Styles      := " + .Styles,
"\n# \u0076im:syntax=make"

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
