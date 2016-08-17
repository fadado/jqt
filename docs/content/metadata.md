---
<%include "site.yaml">
title: Data model
updated: "2016-08-13T07:48:26Z"
---
<%include "macros.m">&
<%include "LINKS.md">&

## General operation

You can provide metadata in the document front matter to be inserted when
rendering the template. Also, `jqt` will accept in the command line  additional
files in [YAML][YAML] or [JSON][JSON] to be merged with
the front matter. This is described on the bottom of this diagram:

<%include "FLOW.md">

When invoking `jqt` you can use the following options to define the additional input
metadata and influence JSON preprocessing:

<%include "opt/D.md">
<%include "opt/f.md">
<%include "opt/I.md">
<%include "opt/M.md">
<%include "opt/m.md">

## Data formats

### YAML

Document front matter metadata and additional input YAML files will be converted to
JSON and merged to be the `jq` input in the render stage.

### JSON

Additional JSON input can be provided in external files. The files are
preprocessed using [GPP][GPP], and all the expected options are available, like
defining new macros, include other files, etc.

#### Macro calls

The macro syntax used by _jqt_ in JSON files is different
for predefined macros and for user defined macros:

* The predefined macro names are preceded with the characters <code>&lt;!</code> and the macro calls finishes with the character `>`.
* The user defined macro names for calls without arguments are preceded with the
  character `&` and the macro calls finishes with the character `;`.
* The user defined macro names for calls witht arguments are preceded with the
  character `&`, followed by the character `(`, with arguments separated by
  commas (`,`), and the macro calls finishes with the characters `);`.  

The more common predefined macros have this syntax:

```
<!defeval x y>
<!define x y>
<!elif expr>
<!else>
<!endif>
<!eval expr>
<!if expr>
<!ifdef x>
<!ifeq x y>
<!ifndef x>
<!ifneq x y>
<!include file>
<!undef x>
```

Inside macro definitions argument references are prefixed by a dollar (`$1`, `$2`, etc.):

#### Skips

The main use of the preprocessor is to remove comments in the CPP style:

```
/* block comments */
// line comments
```

This table summarize all the available skips in JSON files:

 Delimiters         Macro expansion     Delimiters removed  Content removed
-------------       ---------------     ------------------  ---------------
`\\n`[^2]           No                  Yes                 There is no content
`/*` `*/`           No                  Yes                 Yes
`//` `\n`[^1]       No                  Yes                 Yes
`"` `"`             Yes                 No                  No
`` ` `` `` ` ``     No                  Yes                 No

Table: **Semantics for all JSON skips**

[^1]: This represents a newline character.
[^2]: A backslash followed by a newline is treated as a line continuation (that
is, the backslash and the newline are removed and effectively ignored).

### Data conversion

When preparing data inputs sometimes you need to mix files in several formats.
To make easy integrate metadata from several sources _jqt_ comes with the
following utilities to convert between CSV, JSON and YAML formats:

* `csv2json`
* `csv2yaml`
* `json2csv`
* `json2yaml`
* `yaml2csv`
* `yaml2json`

These utilities are filters that read standard input or a file passed as an
argument and write to standard output.

## Querying data files

Sometimes you want to apply queries in the _jq_ style to CSV or YAML files,
in the same style as _jq_ processes JSON data.
As a wrappers to `jq` you have the following utilities shipped with _jqt_:

* `cq`
* `yq`

These utilities imitate at maximum the `jq` command line interface, for example
not requiring redirection of input:

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

Read the output of `yq --help` for more information.

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
