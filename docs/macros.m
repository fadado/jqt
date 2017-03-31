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
<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=perl
#>&
