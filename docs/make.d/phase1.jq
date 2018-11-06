########################################################################
# phase1.jq -- Define contents for `$(Metadata)/phase2.make`.
#
# jq -r -f phase1.jq
#   < $(Metadata)/site.json
#   > $(Metadata)/phase1.make

#
# Output makefile
#
"__phase_1   := 1\n",
"Assets      := " + .Assets,
"Blocks      := " + .Blocks,
"Content     := " + .Content,
"Data        := " + .Data,
"Destination := " + .Destination,
"Layouts     := " + .Layouts,
"Styles      := " + .Styles,
"\n# \u0076im:syntax=make"

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
