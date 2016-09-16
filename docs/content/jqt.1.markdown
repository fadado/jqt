% JQT(1) Version <%include ../VERSION> | jq based web template engine
%
% Aug 2016

# NAME

**jqt** – jq based web template engine

# SYNOPSIS

| **jqt** [**-h** | **--help** | **-p** | **-V** | **--version**]
| **jqt** [options] < infile > result
| **jqt** [options] infile > result
| **jqt** [options] infile result

# DESCRIPTION

**jqt** orchestrates several shell utilities to transform MarkDown text and
YAML or JSON data into a final HTML document. The transformation is driven by a template,
where HTML is mixed with **jq** snippets to implement the transformation logic.

# OPTIONS

<%include opt/4.txt>
<%include opt/C.txt>
<%include opt/D.txt>
<%include opt/d.txt>
<%include opt/e.txt>
<%include opt/H.txt>
<%include opt/h.txt>
<%include opt/I.txt>
<%include opt/i.txt>
<%include opt/j.txt>
<%include opt/L.txt>
<%include opt/M.txt>
<%include opt/m.txt>
<%include opt/n.txt>
<%include opt/P.txt>
<%include opt/p.txt>
<%include opt/r.txt>
<%include opt/S.txt>
<%include opt/T.txt>
<%include opt/t.txt>
<%include opt/V.txt>

# FILES

/usr/local/share/jqt/libjqt.m
:   Initialization file for `gpp`.

/usr/local/share/jqt/libjqt.jqt
:   Initialization file for `jq`.

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

**gpp(1)**, **jq(1)**, **pandoc(1)**

**jqt** home page: <https://fadado.github.com/jqt/>

<!--
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
-->
