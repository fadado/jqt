---
<%include "site.yaml">
title: Templates syntax
updated: "2016-08-13T07:48:26Z"
---
<%include "macros.m">&
<%include "LINKS.md">&

## General operation

_jqt_ will transform your templates into _jq_ scripts, but before that
[GPP][GPP] is used to preprocess them. The generated script will be executed,
in the render stage, to generate the final HTML document while consuming the
merged JSON inputs.
This is described on the top of this diagram:

<%include "FLOW.md">

You can pass the following options to `jqt` to modify template evaluation:

<%include "opt/D.md">
<%include "opt/I.md">
<%include "opt/i.md">
<%include "opt/j.md">
<%include "opt/L.md">

## Syntax

A template is a file with UTF-8-encoded text, with a few kinds of delimited
statements intermixed.  This is a complete template example:

<%include "EXAMPLE.md">&

Main features:

* One line statements begin with optional space and `{%...%}`. The rest of the
  line is in the nested block.
* Multiline blocks begin with optional space and `{%...%}`.
* Multiline blocks finish with optional space and `{% end %}`.
* Raw blocks are enclode between `{% raw %}` and `{%%}` marks.
* The input metadata provided to _jq_ is available in the dot (`.`) and the global variable `M$`.

### Preprocessing

Templates are preprocessed using [GPP][GPP]. All the expected options are available,
like defining new macros, include other files, etc.

#### Syntax of macros

Macro definition:

```
<%define HEAD_TITLE
  <title>{{.front.title}} &ndash; {{.site.title}}</title>
>&
```

Macro call examples:

```
<meta name="generator" content="jqt v<%include "../VERSION">"/>

<%include "default.html">

<%partial analytics 'UA-82432866-1'>&
```

Conditional macro call:

```
<%ifndef HEAD_TITLE>&
    <title>{{.front.title}}</title>
<%else><%call HEAD_TITLE><%endif>&
```

#### Skips

Some fragments of text are skipped during macro expansion.

```
<# block comments, removed, must end in newline (also removed) #>
```

```
Continuation lines using ampersand (removed with the newline character)&
```

Strings are copied to the output, but evaluation of macros inside strings can
be disabled.  String delimiters can be copied, or not, to the output.

~~~
<%sc 'single quoted strings, only available in user defined macro calls'>
<%sc "double quoted strings, only available in user defined macro calls'>
<!-- XML comments, not removed -->
All the jqt template tags: {#...#}, {%...%}, {{...}} 
~~~

Templates are preprocessed like MarkDown input, but the skips available are no the same.
This table summarize all the skips available:

This table summarize all the skips available:

 Delimiters         Place                   Macro expansion     Delimiters removed  Content removed
-------------       -----                   ---------------     ------------------  ---------------
`&\n`[^1]           Template text           No                  Yes                 There is no content
`<#` `#>`           Template text           No                  Yes                 Yes
`'` `'`             User defined macros     No                  Yes                 No
`"` `"`             User defined macros     Yes                 Yes                 No
`<!--` `-->`        Template text           No                  No                  No
`{{` `}}`           Template text           No                  No                  No
`{%` `%}`           Template text           No                  No                  No
`{#` `#}`           Template text           No                  No                  No

Table: **Semantics for all template skips**

[^1]: An ampersand followed by a newline is treated as a line continuation (that
is, the ampersand and the newline are removed and effectively ignored).

### _jq_ fragments

The delimiters used by _jqt_ are as follows:

Delimiters    Purpose
----------    -----------------------------------
`{# ... #}`   comments not included in the output
`{{ ... }}`   expressions to evaluate and print
`{% ... %}`   control statements

Table: **Delimiters used in _jqt_ templates**

The text inside the expressions and control delimiters is normal _jq_ code, when as
a bonus, the `M$` global variable point to `jq` JSON input (the initial `.`
&ndash;dot&ndash;).

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
