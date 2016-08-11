<#
 # libjqt GPP macros
 #>
<#
 # Redefine, for clarity, again the GPP mode for jqt
 #>
<%mode user "<%" ">" "\B" "\B" "\W>" "<" ">" "$" "">&
<%mode meta "<%" ">" "\B" "\B" "\W>" "<" ">">&
<%mode string ccc "&\n" "">&
<%mode string ccc "<#" "#>\n">&
<%mode string iqi "'" "'" "">&
<%mode string iQi "\"" "\"" "">&
<%mode string sss "<!--" "-->" "">&
<%mode string sss "\n```" "\n```" "">&
<%mode string sss "\n~~~" "\n~~~" "">&
<%mode string sss "\n---\n" "\n---\n" "">&
<%mode string sss "{{" "}}" "">&
<%mode string sss "{%" "%}" "">&
<%mode string sss "{#" "#}" "">&
<#
 # Quote character, only for this file
 #>
<%mode quote "\\">&
<#
 # <%partial name arg...>
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
 # <%shortcode name>... <%name arg...>
 # Define name as a macro with contents of name.m as a body.
 # Assume 'm' filename extension.
 # Equivalent to: <%defeval name <%include name.m>>
 #>
<%define shortcode
    <%defeval _shortcode
        <\%defeval $1
            <\%include $1.m>
        >
    ><%_shortcode><%undef _shortcode>
>&
<#
 # <%call scan text>
 # Evaluate text with macro calls.
 #>
<%define scan
    <%defeval _scan $1><%_scan><%undef _scan>
>&
<#
 # <%call name arg...>
 # Call a macro by name.
 #>
<%define call
    <%defeval _call
       <\%$1 "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9">
    ><%_call><%undef _call>
>&
<#
 # <%append name text>
 # Equivalent to: <%defeval name <%name>text.>
 #>
<%define append
    <%defeval _append
        <\%defeval $1 <%call $1>$2>
    ><%_append><%undef _append>
>&
<#
 # vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=perl
 #>
