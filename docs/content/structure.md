---
layout: page
title: Defining the page structure with jqt
description: Web pages structure is defined by the HTML markup.
keywords:  jqt, jq, gpp, preprocessing, template engine
updated: "2016-08-28T10:27:09Z"
---
<%include macros.m>&
<%include content/LINKS.txt>&

# Page structure

The same content can be delivered to the Web in different structured formats, and the
transformation of that content in the final pages must be completely automatic.

## General operation

Web pages structure is defined by the HTML markup, and using _jqt_ it is
added to the input content and data using a template.
_jqt_ transforms templates into [_jq_][JQ] scripts, but before that
[GPP][GPP] is used to preprocess them. The generated script will be combined
with the document and data inputs in the render stage to produce the
final HTML page.
This is described on the top of this diagram:

<%include content/FLOW.txt>

<details>

<summary>
When invoking `jqt` you can use the `-D`, `-I`, `-i`, `-j` and `-L` options to modify template
rendering:
</summary>

<%include content/opt/D.txt>
<%include content/opt/I.txt>
<%include content/opt/i.txt>
<%include content/opt/j.txt>
<%include content/opt/L.txt>

</details>

## Template syntax

A template is a text file with intermixed snippets of [_jq_][JQ] code. Snippets can be
<dfn>expressions</dfn> (delimited by `{{` and `}}`), which get replaced with
values when a template is rendered and <dfn>actions</dfn> (delimited by `{%` and `%}`), which control the logic of the
template.  Comments (delimited by `{#` and `#}`) are ignored and not copied to the output.
This is a complete template example:

<%include content/EXAMPLE.txt>&

### Preprocessing

Templates are preprocessed using [GPP][GPP]. All the expected options in a preprocessor are available,
like defining new macros, include other files, etc. For example, a template fragment
like

```HTML
<meta name="generator" content="jqt v<%include ../VERSION>"/>
```

will expand to the string <code>&lt;meta name="generator" content="jqt v<%include ../VERSION>"/&gt;</code>
as you can see in the internal code of this page.

#### Macro calls

The macro syntax used by _jqt_ in templates and MarkDown documents precedes macro names with the characters `<%`
and finishes the macro calls with the character `>`.
Here are some of the predefined macros:

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

Inside macro definitions parameters are prefixed by a dollar (`$1`, `$2`, etc.),
but named parameters are also possible:

```
<%define stylesheet
    <link rel="stylesheet" type="text/css" href="$1"/>
>
```

Predefined macros and user define macros have the same call sequence:

```
<%include head.html>
<%stylesheet jqt.css>
```

With these simple tools is possible to emulate features considered advanced in some template engines,
like template inheritance (also known as _blocks_). For example, in the base template (assume it is named `default.html`)
you can put this conditional macro call to define a default title block:

```
<%ifndef HEAD_TITLE>
    <title>{{.page.title}}</title> {# default block #}
<%else><%call HEAD_TITLE><%endif>
```

And in the derived template you can define a new macro for the desired block,
before include the base template:

```
<%define HEAD_TITLE
  <title>{{.page.title}} – {{.site.title}}</title>
>
<%include default.html>
```

In addition to [GPP][GPP] predefined macros _jqt_ define some macros to be
included in the render stage. The
more useful will be perhaps `<%partial name arg...>`, to include a template
file passing arguments to it and `<%call name arg...>`, to call a macro by name.

Warning: you must see the [GPP manual][GPPMAN] if you want to know all the gory details.

#### Skips

Some fragments of text are skipped during macro expansion, like comments,
continuation lines and delimited strings of characters:

```
<# Block comments, removed, must end in newline (also removed) #>
Continuation lines using an ampersand &
just before the newline character
```

_Strings_ are copied to the output, but evaluation of macros inside strings can
be enabled or disabled.  String delimiters can be copied, or not, to the output:

~~~HTML
<!-- XML comments -->
<%sc 'Single quoted strings, only available in user defined macro calls'>
<%sc "Double quoted strings, only available in user defined macro calls">
All jqt template delimited regions: {#...#}, {%...%}, {{...}} 
~~~

This table summarizes all the available skips:

 Delimiters         Macro expansion     Delimiters removed  Content removed
-------------       ---------------     ------------------  ---------------
`&\n`[^1]           No                  Yes                 There is no content
`<#` `#>`           No                  Yes                 Yes
`'` `'`[^2]         No                  Yes                 No
`"` `"`[^3]         Yes                 Yes                 No
`<!--` `-->`        No                  No                  No
`{{` `}}`           No                  No                  No
`{%` `%}`           No                  No                  No
`{#` `#}`           No                  No                  No

Table: **Semantics for all _jqt_ template skips**

[^1]: An ampersand followed by a newline is treated as a line continuation (that
is, the ampersand and the newline are removed and effectively ignored).
[^2]: Only inside user defined macros.
[^3]: Only inside user defined macros.

### Code snippets

The input text for a template is UTF-8 text with intermixed snippets of [_jq_][JQ] 
code. Snippets can be _expressions_, _actions_ and _comments_.  The delimiters
used by _jqt_ are as follows:

Delimiters    Purpose
----------    -----------------------------------
`{{ ... }}`   Expressions to evaluate
`{% ... %}`   Actions for conditional evaluation and loops
`{# ... #}`   Comments not included in the output

Table: **Delimiters used in _jqt_ templates**

#### Expressions

The text in expressions and actions is normal [_jq_][JQ] code, where as
a bonus, the `$M` global variable points to the `jq` JSON input (the initial `.`).
The rules for expression evaluation are very simple:

* If an expression evaluates to `empty` the whole line vanishes.
* If an expression produces only one value the delimited snippet is replaced with this value.
* If an expression produces multiple values the whole line is repeated multiple
  times, with the expression evaluated again each time.

Warning: if a line contains two or more expressions producing multiple values a
cartesian product is generated!

#### Actions

There are two kinds of actions:

* <dfn>One line actions</dfn>: lines beginning with optional space, followed by a
  `{%...%}` snippet and more text.
* <dfn>Multiline actions</dfn>: initial line prefixed with optional space,
  followed by an opening `{%...%}` snippet and a newline character
  immediately after the character `}`;
  then zero or more template lines; final line prefixed with optional space,
  the ending `{% end %}` snippet and a newline character.  Multiline actions can nest and
  contain expressions and other actions.

The evaluation rules for one line actions are as follows:

* If the delimited snippet evaluates to `empty` the whole line vanishes.
* Otherwise, for each value produced the text following the
  snippet is evaluated with the value assigned to the dot (`.`). The initial
  dot is still available in the global variable `$M`.

The evaluation rules for multiline actions are as follows:

* If the opening snippet evaluates to `empty` all lines until the ending snippet disappear.
* Otherwise, for each value produced the lines until the ending snippet
  are evaluated with the value assigned to the dot (`.`). The initial dot is
  still available in the global variable `$M`.

<# Warning: raw blocks are not documented because they are CONTENT! #>

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
