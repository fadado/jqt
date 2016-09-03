---
title: Authored content
updated: "2016-08-28T10:27:09Z"
---
<%include macros.m>&
<%include LINKS.txt>&

## General operation

_jqt_ transforms [MarkDown][MARKDOWN] documents to HTML using Pandoc,
but before that [GPP][GPP] is used to preprocess them. Pandoc's output
is then merged with the [YAML][YAML] front matter metadata and other input data before be sended
to the render stage.  This is described on the middle of this diagram:

<%include FLOW.txt>

When invoking `jqt` you can use the following options to influence document
conversion:

<%include opt/4.txt>
<%include opt/D.txt>
<%include opt/d.txt>
<%include opt/I.txt>

## File structure

Document files contain MarkDown text preceded by an optional YAML front matter.

### Front matter

_jqt_ extracts the YAML front matter, located at the very beginning of the file,
and injcontent. ects it into the render stage under a global JSON object named `.page`.

### Body

Pandoc converts the document body to HTML,
and _jqt_ injects it into the render stage under the global JSON scalar 
`.page._content`. If the document contains fenced code blocks specifying the language of
the code block, the related highlight CSS code will be in the scalar `.page._highlight`. Also, the
HTML table of contents is available in the scalar `.page._toc`, and the path to the document
file in the scalar `.page._path`.

## Document syntax

Document's conversion has two stages. In the first the text is preprocessed,
and the second does the proper conversion to HTML.

### Preprocessing

The MarkDown input content is preprocessed using [GPP][GPP]. All the expected options in a preprocessor are available,
like defining new macros, include other files, etc. For example, a macro call
like `<%include "../VERSION">` will expand to he string <code><%include "../VERSION"></code>
as you can see in this paragraph and on the top of these pages.

#### Macro calls

All the power of GPP is available to help you when
[transcluding](https://en.wikipedia.org/wiki/Wikipedia:Transclusion)
the input MarkDown document. The macro syntax used by _jqt_ in input documents precedes macro names with the characters `<%`
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

```
<%define sc
    <span style="font-variant:small-caps;">$1</span>
>
```

Predefined macros and user define macros have the same call sequence:

```
<%include LINKS.txt>
<%sc 'A title in small caps'>
```

Warning: you must read the [GPP manual][GPPMAN] if you want to know all the gory details.

#### Skips

Some fragments of text are skipped during macro expansion, like comments,
continuation lines and arbitrary but delimited strings of characters:

```
<# Block comments, removed, must end in newline (also removed) #>
Continuation lines using an ampersand &
just before the newline character
```

_Strings_ are copied to the output, but evaluation of macros inside strings can
be enabled or disabled.  String delimiters can be copied, or not, to the output:

~~~
<!-- XML comments -->
<%sc 'Single quoted strings, only available in user defined macro calls'>
<%sc "Double quoted strings, only available in user defined macro calls'>
Inline code `inside backticks`
```
Fenced code blocks with tildes (~~~) or backticks (```)
```
~~~

This table summarizes all the available document skips:

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

_jqt_ accept as input format the [Pandoc's MarkDown](http://pandoc.org/MANUAL.html#pandocs-markdown)
variant, with the <a href="http://pandoc.org/MANUAL.html#extension-pandoc_title_block">title block extension</a>
disabled, and produces transitional HTML.  When running `jqt` the following
Pandoc long options can be specified in
the command line and will be forwarded untouched to `pandoc`:

```
    --base-header-level=NUMBER                        --latexmathml[=URL]
    --bibliography=FILE                               --mathjax[=URL]
    --citation-abbreviations=FILE                     --mathml[=URL]
    --columns=NUMBER                                  --mimetex[=URL]
    --csl=FILE                                        --no-highlight
    --email-obfuscation=none|javascript|references    --normalize
    --file-scope                                      --number-offset=NUMBER[,NUMBER,...]
    --gladtex                                         --number-sections
    --highlight-style=STYLE                           --preserve-tabs
    --html-q-tags                                     --section-divs
    --id-prefix=STRING                                --tab-stop=NUMBER
    --indented-code-classes=CLASSES                   --toc-depth=NUMBER
    --jsmath[=URL]                                    --webtex[=URL]
    --katex[=URL]                                     --wrap=[auto|none|preserve]
    --katex-stylesheet
```

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
