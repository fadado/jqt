---
layout: page
title: Managing the data model with jqt
description: jqt combines one template with one MarkDown document and a data model.
keywords:  jqt, JSON, YAML, gpp, preprocessing, data model
updated: "2016-08-28T10:27:09Z"
---
<%include macros.m>&
<%include content/LINKS.txt>&

# Data model

The simplest page always resides on a website, where there is a complex web of
relationships between pages. As we have to imagine these relationships, we need
a way to represent them: this is the data model.

## General operation

_jqt_ is designed to combine one template with one [MarkDown][MARKDOWN] document and a
[data model](https://en.wikipedia.org/wiki/Data_model) to
produce the final HTML result.
To define the data model you can provide metadata in the document front matter to be inserted when
rendering the template. Also, `jqt` accepts additional data files in the command line
in [YAML][YAML] or [JSON][JSON] format to be merged with
the document front matter. This is described on the bottom of this diagram:

<%include content/FLOW.txt>

<details>

<summary>
When invoking `jqt` you can use the `-D`, `-I`, `-M`, `-m`, `-n` and `-T` options to define the additional input
data and influence JSON preprocessing:
</summary>

<%include content/opt/D.txt>
<%include content/opt/I.txt>
<%include content/opt/M.txt>
<%include content/opt/m.txt>
<%include content/opt/n.txt>
<%include content/opt/T.txt>

</details>

## Data formats

### YAML and JSON

Documents front matter metadata and additional input YAML files are converted to
JSON and merged to be the `jq` input in the render stage. No preprocessing is
applied  to YAML data.

The front matter content is available in the global object `.page`. The object
member names prefixed with the underline character (`_`) are reserved, and the following
are provided:

* `.page._content`: the rendered input document.
* `.page._highlight`: CSS styles for highlighted code.
* `.page._path`: the input document pathname as provided to `jqt`.
* `.page._toc`: the rendered input document table of contents.

Additional JSON files can be provided and are merged with front matter metadata
to be the `jq` input in the render stage.

### JSON preprocessing

JSON files are preprocessed using [GPP][GPP], and all the expected options in a
preprocessor are available, like defining new macros, include other files, etc.

#### Macro calls

The macro syntax used by _jqt_ in JSON files is very similar to the syntax used by the traditional
TeX language macro processor, but changing the prefix character `\\` by
`&`.
The more common predefined macros have this syntax:

```
&defeval{x}{y}
&define{x}{y}
&elif{expr}
&else
&endif
&eval{expr}
&if{expr}
&ifdef{x}
&ifeq{x}{y}
&ifndef{x}
&ifneq{x}{y}
&include{file}
&undef{x}
```

Inside macro definitions argument references are prefixed by a dollar (`$1`, `$2`, etc.),
but named arguments are also possible.
The more used features are the inclusion on external files and the definition of simple constants:

```JSON
&define{eur}{\u20AC}
&define{price}{$1 &euro}

{ "price": "&price{100}" }
```

Warning: you must see the [GPP manual][GPPMAN] if you want to know all the gory details.

#### Skips

The main use of the preprocessor is to remove comments in the CPP style:

```CPP
/* Block comments */
// Line comments
```

Double quoted strings are defined as skips, and backticks can be used to
disable macro expansion (inside double quoted strings backticks are ignored).
This table summarizes all the available skips in JSON files:

 Delimiters         Macro expansion     Delimiters removed  Content removed
-------------       ---------------     ------------------  ---------------
`&\n`[^1]           No                  Yes                 There is no content
`/*` `*/`           No                  Yes                 Yes
`//` `\n`[^2]       No                  Yes                 Yes
`` ` `` `` ` ``     No                  Yes                 No
`"` `"`             Yes                 No                  No

Table: **Semantics for all JSON skips**

[^1]: An ampersand followed by a newline is treated as a line continuation (that
is, the ampersand and the newline are removed and effectively ignored).
[^2]: This represents a newline character.

## Tools

### Data conversion

When preparing data inputs sometimes you need to mix files in several formats.
To make easy the integration of data from several sources _jqt_ comes with the
following utilities to convert between CSV, JSON and YAML formats:

* `csv2json`
* `csv2yaml`
* `json2csv`
* `json2yaml`
* `yaml2csv`
* `yaml2json`

These utilities are filters that read standard input or a file passed as an
argument and write to standard output.

### Querying data files

Sometimes you want to apply queries in the _jq_ style to CSV or YAML files,
in the same style as _jq_ processes JSON data.
As wrappers to `jq` you have the following utilities shipped with _jqt_:

* `cq`, apply `jq` to CSV input files.
* `yq`, apply `jq` to YAML input files.

These utilities imitate the `jq` command line interface:

```zsh
$ yq '.store.book[2]' tests/data/store.yaml
---
author: Herman Melville
category: fiction
isbn: 0-553-21311-3
price: 8.99
title: Moby Dick
...
```

You can also preserve `jq` JSON output:

```zsh
$ yq --json -c '.store.book[2]' tests/data/store.yaml
{"category":"fiction","price":8.99,"author":"Herman Melville",...
```

See the output of `yq --help` and `cq --help` for more information.

### Process front matter

<details>

<summary>
When invoking `jqt` you can use the `-e`, `-r` and `-t` options to extract, remove or
test the presence of front matter data in the input document:
</summary>

<%include content/opt/e.txt>
<%include content/opt/r.txt>
<%include content/opt/t.txt>

</details>

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
