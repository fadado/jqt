<# recursion #>&
<%define countdown
<%if $1>&
$1...
<%define _countdown <%countdown $1>>&
<%else>&
Done!
<%define _countdown>&
<%endif>&
<%_countdown <%eval $1-1>>&
>&
<%countdown 10>&
