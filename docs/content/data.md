---
<%include "config.yaml">
title: Data model
updated: "2016-08-13T07:48:26Z"
---
<%include "macros.m">&
<%include "LINKS.MD">&

## General operation

_jqt_ is designed to combine one template with one [MarkDown][MARKDOWN] document and a
[data model](https://en.wikipedia.org/wiki/Data_model) to
produce the final HTML result.
To define the data model you can provide metadata in the document front matter to be inserted when
rendering the template. Also, `jqt` accepts additional data files in the command line
in [YAML][YAML] or [JSON][JSON] format to be merged with
the document front matter. This is described on the bottom of this diagram:

<%include "FLOW.MD">

When invoking `jqt` you can use the following options to define the additional input
data and influence JSON preprocessing:

<%include "opt/D.md">
<%include "opt/f.md">
<%include "opt/I.md">
<%include "opt/M.md">
<%include "opt/m.md">
<%include "opt/T.md">

## Data formats

### YAML

Document front matter metadata and additional input YAML files are converted to
JSON and merged to be the `jq` input in the render stage.

### JSON

Additional JSON files can be provided and are merged with front matter metadata
to be the `jq` input in the render stage.  The files are preprocessed using
[GPP][GPP], and all the expected options in a preprocessor are available,
like defining new macros, include other files, etc.

#### Macro calls

The macro syntax used by _jqt_ in JSON files is different
for predefined macros and for user defined macros:

* The predefined macro names are preceded with the characters
  `<%` and the macro calls finishes with the character `>`.
* The user defined macro names for calls without arguments are preceded with
  the character `&` and the macro calls finishes with the character `;`.
* The user defined macro names for calls with arguments are preceded with the
  character `&`, then followed by the character `(`, accept arguments separated by
  commas (`,`), and the macro calls finishes with the character `)`.  

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
<%define euro \u20AC>
<%define price $1 &euro;>

{ "price": "&price(100)" }
```

Warning: you must read the [GPP manual][GPPMAN] if you want to know all the gory details.

#### Skips

The main use of the preprocessor is to remove comments in the CPP style:

```
/* Block comments */
// Line comments
```

Double quoted strings are also defined as skips, and backticks can be used to
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
As a wrappers to `jq` you have the following utilities shipped with _jqt_:

* `cq`, apply `jq` to CSV input files.
* `yq`, apply `jq` to YAML input files.

These utilities imitate at maximum the `jq` command line interface:

```
$ yq '.store.book[2]' tests/data/store.yaml
---
author: Herman Melville
category: fiction
isbn: 0-553-21311-3
price: 8.99
title: Moby Dick
...
```

You can also ask for JSON output:

```
$ yq --json -c '.store.book[2]' tests/data/store.yaml
{"category":"fiction","price":8.99,"author":"Herman Melville",...
```

Read the output of `yq --help` and `cq --help` for more information.

### Process front matter

When invoking `jqt` you can use the following options to extract, remove or
test the presence of front matter data in the input document:

<%include "opt/e.md">
<%include "opt/r.md">
<%include "opt/t.md">

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
