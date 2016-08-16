% JQT(1) Version <%include ../VERSION> | jq based web template engine
%
% Aug 2016

# NAME

**jqt** – jq based web template engine

# SYNOPSIS

| **jqt** \[options] < infile > result
| **jqt** \[options] infile > result
| **jqt** \[options] infile result
| **jqt** \[**-h**|**--help**|**-V**|**--version**]

# DESCRIPTION

**jqt** orchestrates several shell utilities to transform MarkDown text and
YAML or JSON data into a final HTML document. The transformation is driven by a template,
where HTML is mixed with **jq** snippets to implement the transformation logic.

# OPTIONS

<%include "opt/4.md">
<%include "opt/C.md">
<%include "opt/D.md">
<%include "opt/d.md">
<%include "opt/E.md">
<%include "opt/e.md">
<%include "opt/f.md">
<%include "opt/H.md">
<%include "opt/h.md">
<%include "opt/I.md">
<%include "opt/i.md">
<%include "opt/j.md">
<%include "opt/L.md">
<%include "opt/M.md">
<%include "opt/m.md">
<%include "opt/n.md">
<%include "opt/P.md">
<%include "opt/p.md">
<%include "opt/r.md">
<%include "opt/S.md">
<%include "opt/t.md">
<%include "opt/V.md">

# FILES

/usr/local/share/jqt/libjqt.m
:   Initialization file for `gpp`.

/usr/local/share/jqt/libjqt.jqt
:   Initialization files for `jq`.

/usr/local/share/jqt/\*.m
:   Macro example files for `gpp`.

# BUGS

See GitHub issues: <https://github.com/fadado/jqt/issues>

# AUTHOR

**jqt** was written by Joan Josep Ordinas Rosa <jordinas@gmail.com>.

# COPYRIGHT

Copyright © 2015 Joan Josep Ordinas Rosa.
**jqt** is licensed under the MIT license (code) and the CC-BY-3.0 license (documents).

# SEE ALSO

**gpp(1)**, **jq(1)**

**jqt** home page: <https://fadado.github.com/jqt/>
