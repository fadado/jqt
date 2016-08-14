<#
 # Extra macros for this site
 #>
<# Quote character, only for this file #>
<%mode quote "\\">&
<#
 # Usage: <%sc word>
 #        <%sc 'text with spaces'>
 #>
<%define sc <span style="font-variant:small-caps;">$1</span>>&
<#
 # Usage: <%cite word>
 #        <%cite 'text with spaces'>
 #>
<%define cite <cite>$1</cite>>&
<#
 # <%inceval name arg...>
 # Like include but evaluating filename and passing (up to 8) parameters to the included file.
 #>
<%define inceval
    <%defeval _inceval
        <\%defeval _inceval
            <\%include "$1">
        >
    ><%_inceval><%_inceval "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"><%undef _inceval>
>&
<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=perl
#>
