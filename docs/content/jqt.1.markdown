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

<%include content/opt/4.txt>
<%include content/opt/C.txt>
<%include content/opt/D.txt>
<%include content/opt/d.txt>
<%include content/opt/e.txt>
<%include content/opt/H.txt>
<%include content/opt/h.txt>
<%include content/opt/I.txt>
<%include content/opt/i.txt>
<%include content/opt/j.txt>
<%include content/opt/L.txt>
<%include content/opt/M.txt>
<%include content/opt/m.txt>
<%include content/opt/n.txt>
<%include content/opt/P.txt>
<%include content/opt/p.txt>
<%include content/opt/r.txt>
<%include content/opt/S.txt>
<%include content/opt/T.txt>
<%include content/opt/t.txt>
<%include content/opt/V.txt>
<%include content/opt/w.txt>

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
