---
<%include "site.yaml">
title: Template syntax
updated: "2016-08-13T07:48:26Z"
---
<%include "macros.m">&
<%include "LINKS.md">&

## General operation

_jqt_ will transform your template into a [_jq_][JQ]  script, but before that
[GPP][GPP] is used to preprocess them. The generated script will be combined
with the document and metadata inputs, in the render stage, to produce the
final HTML document.
This is described on the top of this diagram:

<%include "FLOW.md">

When invoking `jqt` you cas use the following options to modify the template
rendering:

<%include "opt/D.md">
<%include "opt/I.md">
<%include "opt/i.md">
<%include "opt/j.md">
<%include "opt/L.md">

## Template syntax

A template is a text file with intermixed snippets of _jq_ code. Snippets can be
<dfn>expressions</dfn> (delimited by `{{` and `}}`), which get replaced with
values when a template is rendered and <dfn>actions</dfn> (delimited by `{%` and `%}`), which control the logic of the
template.  Comments (delimited by `{#` and `#}`) are ignored and not copied to the output.
This is a complete template example:

<%include "EXAMPLE.md">&

### Preprocessing

Templates are preprocessed using [GPP][GPP]. All the expected options are available,
like defining new macros, include other files, etc. For example, a template fragment
like

```HTML
<meta name="generator" content="jqt v<%include "../VERSION">"/>
```

will expand to the string <code>&lt;meta name="generator" content="jqt v<%include "../VERSION">"/&gt;</code>
as you can see in the internal code of this page.

#### Macro calls

The macro syntax used by _jqt_ precedes macro names with the characters `<%`
and finishes the macro calls with the character `>`.
The more common predefined macros have this syntax:

```
<%defeval x y>
<%define x y>
<%elif expr>
<%else>
<%endif>
<%eval expr>
<%if expr>
<%ifdef x>
<%ifeq x y>
<%ifndef x>
<%ifneq x y>
<%include file>
<%undef x>
```

Inside macro definitions argument references are prefixed by a dollar (`$1`, `$2`, etc.):

With these simple tools is possible to emulate features considered advanced in some template engines,
like template inheritance (also known as _blocks_). For example, in the base template (assume it is named `default.html`)
you must put this conditional macro call:

```
<%ifndef HEAD_TITLE>
    <title>{{.front.title}}</title> {# default block #}
<%else><%call HEAD_TITLE><%endif>
```

And in the derived template you define a macro for the desired block, and include the base template:

```
<%define HEAD_TITLE
  <title>{{.front.title}} &ndash; {{.site.title}}</title>
>&
<%include "default.html">
```

In addition to GPP predefined macros _jqt_ define in the file `libjqt.m`,
always included in the render stage, a little library of macros. The
more useful will be perhaps `<%partial name arg...>`, to include a template
file passing arguments to it, and `<%call name arg...>`, to call a macro by name.

Warning: you must read the [GPP manual](https://files.nothingisreal.com/software/gpp/gpp.html)
if you want to know all the gory details.

#### Skips

Some fragments of text are skipped during macro expansion, like comments,
continuation lines and arbitrary but delimited strings of characters:

```
<# block comments, removed, must end in newline (also removed) #>
Continuation lines using an ampersand just before the newline character&
```

_Strings_ are copied to the output, but evaluation of macros inside strings can
be enabled or disabled.  String delimiters can be copied, or not, to the output:

~~~
<!-- XML comments -->
<%sc 'single quoted strings, only available in user defined macro calls'>
<%sc "double quoted strings, only available in user defined macro calls'>
All the jqt template delimited regions: {#...#}, {%...%}, {{...}} 
~~~

This table summarize all the available template skips:

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

### Code snippets

The input text for a template is UTF-8 text with 
intermixed snippets of _jq_ code. Snippets can be
expressions, actions and comments.
The delimiters used by _jqt_ are as follows:

Delimiters    Purpose
----------    -----------------------------------
`{{ ... }}`   expressions to evaluate and print
`{% ... %}`   actions for conditional and evaluation and loops
`{# ... #}`   comments not included in the output

Table: **Delimiters used in _jqt_ templates**

#### Expressions

The text inside expressions and actions is normal _jq_ code, where as
a bonus, the `M$` global variable points to the `jq` JSON input (the initial `.`).
The rules for expression evaluation are very simple:

* If an expression evaluates to `empty` the whole line vanishes.
* If an expression produces only one value the snippet is replaced with this value.
* If an expression produces multiple values the whole line is repeated multiple
  times, whith the expression evaluated again each time.

#### Actions

There are two kinds of actions:

* <dfn>One line actions</dfn>: lines beginning with optional space, followed by a
  `{%...%}` snippet and more text.
* <dfn>Multiline actions</dfn>: first line beginning with optional space, followed by an opening `{%...%}` snippet and a newline;
  zero or more template lines; final line  beginning with optional space,  the ending `{% end %}` snippets and a newline.
  Multiline actions can nest and contain expressions and one line actions.

The evaluation rules for one line actions are as follows:

* If the snippet evaluates to `empty` the whole line vanishes.
* Otherwise, for each value produced by the snippet the text following the
  snippet is evaluated with the value assigned to the dot (`.`). The initial
  dot is still available in the global variable `M$`.

The evaluation rules for multiline actions are as follows:

* If the opening snippet evaluates to `empty` the all the lines until the ending snippet vanishes.
* Otherwise, for each value produced by the opening snippet the lines until the ending snippet
  are evaluated with the value assigned to the dot (`.`). The initial dot is
  still available in the global variable `M$`.

<# Warning: raw blocks not documented #>

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
