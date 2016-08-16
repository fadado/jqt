---
<%include "site.yaml">
title: Content documents
updated: "2016-08-13T07:48:26Z"
---
<%include "macros.m">&
<%include "LINKS.md">&

## General operation

_jqt_ will transform your MarkDown documents to HTML using
[Pandoc][PANDOC], but before that [GPP][GPP] is used to preprocess the
documents. Pandoc's output is then merged with the YAML front matter and the input metadata
before send it to the render stage.
This is described on the middle of this diagram:

<%include "FLOW.md">

You can pass the following options to `jqt` to modify document evaluation:

<%include "opt/4.md">
<%include "opt/D.md">
<%include "opt/I.md">
<%include "opt/d.md">
<%include "opt/n.md">

## Document structure

Documents contains MarkDown text with an optional YAML front matter.

### Front matter

Pandoc accepts YAML metadata intermixed with the MarkDown content. _jqt_ will
extract the YAML front matter, located at the very begining of the file,
transform it to JSON with the top level scalar elements converted to MarkDown,
and inject it into the render stage under the global object named `.front`.

### Body

Pandoc will convert the document body to HTML,
and _jqt_ will inject it into the render stage under the global scalar named
`.body`. If the document contains fenced code blocks specifying the language of
the code block, the highlight code will be in the scalar `.front._css`. Also, the
table of contents will be in the scalar `.front._toc`.

## Document conversion

The document conversion has two stages. In the first the text is preprocessed,
and the second does the proper conversion to HTML.

### Preprocessing

The MarkDown input content is preprocessed using [GPP][GPP]. All the expected options are available,
like defining new macros, include other files, etc. For example, a macro call
like `<%include "../VERSION">` will expand to he string <code><%include "../VERSION"></code>
as you can see on the top of this page.

#### Syntax of macros

Macro definition:

```
<%define sc
    <span style="font-variant:small-caps;">$1</span>
>&
```

Macro call examples:

```
<%sc 'A title in small caps'>

<%include "LINKS.md">&
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
Inline code `inside backticks`
<!-- XML comments, not removed -->
```
Fenced code blocks with tildes (~~~) or backticks (```)
```
~~~

This table summarize all the skips available:

 Delimiters     Place                   Macro expansion     Delimiters removed  Content removed
-------------   -----                   ---------------     ------------------  ---------------
&#60;# #>       Text                    No                  Yes                 Yes
' '             User defined macros     No                  Yes                 No
" "             User defined macros     Yes                 Yes                 No
&#96; &#96;     Text                    No                  No                  No
&lt;!-- -->     Text                    No                  No                  No
&#96;``         Text                    No                  No                  No
&#126;~~        Text                    No                  No                  No

Table: **Semantics for all MarkDown skips**

### HTML Generation

_jqt_ accept as input format the Pandoc's MarkDown variant, with the title
block extension disabled.  When running `jqt` several Pandoc long options can
be forwarded to `pandoc`:

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
