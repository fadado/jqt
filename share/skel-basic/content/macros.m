<#
 # Extra macros for this site
 #>&
<# Quote character, only for this file #>&
<%mode quote "\\">&
<# sc -- small caps style
 # Usage: <%sc word>
 #        <%sc 'text with spaces'>
 #>&
<%define sc <span style="font-variant:small-caps;">$1</span>>&
<# cite -- HTML cite element
 # Usage: <%cite word>
 #        <%cite 'text with spaces'>
 #>&
<%define cite <cite>$1</cite>>&
<# dfn -- HTML dfn element
 # Usage: <%dfn word>
 #        <%dfn 'text with spaces'>
 #>&
<%define dfn <dfn>$1</dfn>>&
<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=perl
#>&
