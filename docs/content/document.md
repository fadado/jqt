---
<%include "site.yaml">
title: Content documents
updated: "2016-08-13T07:48:26Z"
---
<%include "macros.m">&
<%include "LINKS.md">&

## Document structure

### Front matter

### Body

## Processing

### Preprocessing

The MarkDown input content is preprocessed using `gpp`

#### Syntax of macros

```
<%define sc
    <span style="font-variant:small-caps;">$1</span>
>
```

```
continuation lines using ampersand&
```

#### Skips

##### Comments

Comments are no cpied to the output.

Macros evaluation inside comments is disabled.

```
<# block comments, removed, including terminating new-line #>
```

##### Strings

Strings are copied to the output, but evaluation of macros inside strings can
be is disabled.

String delimiters can be copied, or not, to the output.

```
<%sc 'single quoted strings only in macro calls'>
<%sc "double quoted strings, expanding macros inside, only in macro calls'>
<!-- XML comments, not removed -->
Fenced code blocks with tildes (~~~) or backticks (```)
```

### HTML Generation

## Pandoc options

When running `jqt` several long options are forwarded to `pandoc`:

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
