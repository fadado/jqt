# phase1.jq < $(Metadata)/site.json > $(Metadata)/phase1.make
# 

# Function to cheat vim
def comment: "# vim:syntax=make";

#
# Format some members as make variables
#
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
