jqt - jq based web template engine [version <%include "../VERSION">]

Usage: jqt [-h | --help | -p | -V | --version]
       jqt [options] < infile > result\
       jqt [options] infile > result\
       jqt [options] infile result

Preprocessor options:

<%include "opt/D.txt">
<%include "opt/I.txt">
<%include "opt/P.txt">

Template options:

<%include "opt/L.txt">
<%include "opt/i.txt">
<%include "opt/j.txt">

Document options:

<%include "opt/4.txt">
<%include "opt/d.txt">

Data options:

<%include "opt/M.txt">
<%include "opt/m.txt">
<%include "opt/T.txt">

Debugging options:

<%include "opt/C.txt">
<%include "opt/H.txt">
<%include "opt/S.txt">

Information options:

<%include "opt/h.txt">
<%include "opt/p.txt">
<%include "opt/V.txt">

See the manpage for full documentation and more options.

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
