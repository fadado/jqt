---
name: Content
layout: page-toc
title: Authoring content in jqt using MarkDown
description: jqt transforms MarkDown documents to HTML using Pandoc.
keywords:  jqt, markdown, pandoc, gpp, preprocessing, authoring content
updated: "2016-08-28T10:27:09Z"
use: [content/macros.m, content/LINKS.txt, content/FLOW.txt, "content/opt/[4DdiT].txt"]
---
<%include content/macros.m>&
<%include content/LINKS.txt>&

# Authoring content

Authors must be freed from any concern regarding the presentation of his
writings, and his dedication to its structure must be the essential minimum:
_MarkDown_ promises and delivers exactly this.

## General operation

<%cite jqt> transforms [MarkDown][MARKDOWN] documents to HTML using [Pandoc][PANDOC],
but before that [GPP][GPP] is used to preprocess them. Pandoc's output
is then merged with the [YAML][YAML] front matter metadata and other input data before be sended
to the render stage.  This is described on the middle of this diagram:

<%include content/FLOW.txt>

<details>

<summary>
When invoking `jqt` you can use the `-4`, `-5`, `-D`, `-d`, and `-I`  options to influence document
conversion:
</summary>

<%include content/opt/4.txt>
<%include content/opt/D.txt>
<%include content/opt/d.txt>
<%include content/opt/I.txt>

</details>

## File structure

Document files contain MarkDown text preceded by an optional YAML front matter.

### Front matter

<%cite jqt> extracts the YAML front matter, located at the very beginning of the file,
and injects it into the render stage under a global JSON object named `._front_matter`.

### Body

Pandoc translates the document body to HTML,
and <%cite jqt> injects it into the render stage under the global JSON scalar 
`._content`. If the document contains fenced code blocks specifying the language of
the code block, the related highlight CSS code will be in the scalar `._highlight`. Also, the
HTML table of contents is available in the scalar `._toc`, and the path to the document
file in the scalar `._source`.

### MarkDown snippets

<details>

<summary>
<%cite jqt> offers also a transformation that can also be considered a kind of preprocessing.
The option `-T` allows the use of YAML files for collections of MarkDown snippets:
</summary>

<%include content/opt/T.txt>

</details>

This feature can be used to collect multiple text snippets in only one file.
The MarkDown can be transformed to HTML and put in a new YAML or JSON file
with a command like this:

```zsh
jqt -T -- text.yaml | yaml2json > snippets.json
```

Then this converted file can be loaded by `jqt` in succesive calls:

```zsh
jqt -m snippets:snippets.json ...
```

Template files can expand the snippets without never containing raw content:

```HTML
<h1>{{.snippets.title}}</h1>
```

This allows the absolute separation of structure and content, as it should be.

## Document syntax

Document's conversion has two stages. In the first the text is preprocessed,
and the second does the proper conversion to HTML.

### Preprocessing

The MarkDown input content is preprocessed using [GPP][GPP]. All the expected options in a preprocessor are available,
like defining new macros, include other files, etc. For example, a macro call
like `<%include "../VERSION">` will expand to he string <code><%include "../VERSION"></code>
as you can see in this paragraph and on the top of these pages.

#### Macro calls

All the power of [GPP][GPP] is available to help you when
[transcluding](https://en.wikipedia.org/wiki/Wikipedia:Transclusion)
the input MarkDown document. The macro syntax used by <%cite jqt> in templates and input documents
precedes macro names with the characters `<%` and finishes the macro calls with
the character `>`. 
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
<%define sc
    <span style="font-variant:small-caps;">$1</span>
>
```

Predefined macros and user define macros have the same call sequence:

```
<%include content/LINKS.txt>
<%sc 'A title in small caps'>
```

Warning: you must see the [GPP manual][GPPMAN] if you want to know all the gory details.

#### Skips

Some fragments of text are skipped during macro expansion, like comments,
continuation lines and arbitrary but delimited strings of characters:

```
<# Block comments, removed, must end in newline (also removed) #>
Continuation lines using an ampersand &
just before the newline character
```

_Strings_ are copied to the output, but evaluation of macros inside strings can
be enabled or disabled depending on the type of string.  Also, string delimiters can
be copied, or not, to the output:

~~~
<!-- XML comments -->
<%sc 'Single quoted strings, only available in user defined macro calls'>
<%sc "Double quoted strings, only available in user defined macro calls">
Inline code `inside backticks`
```
Fenced code blocks with tildes (~~~) or backticks (```)
```
~~~

This table summarizes all the available skips:

 Delimiters                         Macro expansion     Delimiters removed  Content removed
-------------                       ---------------     ------------------  ---------------
`&\n`[^1]                           No                  Yes                 There is no content
`<#` `#>\n`                         No                  Yes                 Yes
`'` `'`[^2]                         No                  Yes                 No
`"` `"`[^3]                         Yes                 Yes                 No
`<!--` `-->`                        No                  No                  No
`` ` `` `` ` ``                     No                  No                  No
<code>\\n&#96;&#96;&#96;</code>[^4] No                  No                  No
`\n~~~`[^5]                         No                  No                  No

Table: **Semantics for all MarkDown document skips**

[^1]: An ampersand followed by a newline is treated as a line continuation (that
is, the ampersand and the newline are removed and effectively ignored).
[^2]: Only inside user defined macros.
[^3]: Only inside user defined macros.
[^4]: Blocks of code fenced between two lines with three or more backticks.
[^5]: Blocks of code fenced between two lines with three or more tildes.

### Pandoc’s Markdown

<%cite jqt> accept as input format for documents the [Pandoc's MarkDown](http://pandoc.org/MANUAL.html#pandocs-markdown)
variant, with the <a href="http://pandoc.org/MANUAL.html#extension-pandoc_title_block">title block extension</a>
disabled, and produces by default transitional HTML.  When running `jqt` the following
Pandoc long options can be specified in
the command line and will be forwarded untouched to `pandoc`:

```
--base-header-level=NUMBER
--bibliography=FILE
--citation-abbreviations=FILE
--columns=NUMBER
--csl=FILE
--email-obfuscation=none|javascript|references
--file-scope
--gladtex
--highlight-style=STYLE
--html-q-tags
--id-prefix=STRING
--indented-code-classes=CLASSES
--jsmath[=URL]
--katex[=URL]
--katex-stylesheet
--latexmathml[=URL]
--mathjax[=URL]
--mathml[=URL]
--mimetex[=URL]
--no-highlight
--normalize
--number-offset=NUMBER[,NUMBER,...]
--number-sections
--preserve-tabs
--section-divs
--tab-stop=NUMBER
--toc-depth=NUMBER
--webtex[=URL]
--wrap=[auto|none|preserve]
```

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
