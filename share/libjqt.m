<#
 # libjqt GPP macros
 #>
<# Quote character, only for this file #>
<%mode quote "\\">&
<#
 # Usage: <%partial name arg...>
 #
 # Like include but passing (up to 8) parameters to the included file.
 # Assume 'm' filename extension.
 #>
<%define partial
    <%defeval _partial
        <\%defeval _partial
            <\%include "$1.m">
        >
    ><%_partial><%_partial "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"><%undef _partial>
>&
<#
 # Usage: <%shortcode name>... <%name arg...>
 #
 # Define name as a macro with contents of name.m as a body.
 # Assume 'm' filename extension.
 # Equivalent to: <%defeval name <%include name.m>>
 #>
<%define shortcode
    <%defeval _shortcode
        <\%defeval $1
            <\%include "$1.m">
        >
    ><%_shortcode><%undef _shortcode>
>&
<#
 # Usage: <%scan text>
 #
 # Evaluate text with macro calls.
 #>
<%define scan
    <%defeval _scan $1><%_scan><%undef _scan>
>&
<#
 # Usage: <%call name arg...>
 #
 # Call a macro by name.
 #>
<%define call
    <%defeval _call
       <\%$1 "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9">
    ><%_call><%undef _call>
>&
<#
 # Usage: <%append name text>
 #
 # Equivalent to: <%defeval name <%name>text.>
 #>
<%define append
    <%defeval _append
        <\%defeval $1 <%call $1>$2>
    ><%_append><%undef _append>
>&
<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=perl
#>
