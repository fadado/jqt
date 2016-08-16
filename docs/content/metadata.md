---
<%include "site.yaml">
title: Data model
updated: "2016-08-13T07:48:26Z"
---
<%include "macros.m">&
<%include "LINKS.md">&

## General operation

_jqt_ will

Metadata in YAML and JSON formats

This is described on the bottom of this diagram:

<%include "FLOW.md">

You can pass the following options to `jqt` to modify metadata evaluation:

<%include "opt/D.md">
<%include "opt/f.md">
<%include "opt/I.md">
<%include "opt/M.md">
<%include "opt/m.md">

## Data XXXXXX

### Preprocessing

The JSON input content is preprocessed using [GPP][GPP]. All the expected options are available,
like defining new macros, include other files, etc. YAML input is not preprocessed.

The main preprocessor use to remove comments in the CPP style.

#### Syntax of macros

Macro definition:

```
<!define X X>&
```

```
Continuation lines using backslash (removed with the newline character)\
```

Macro call examples:

```
...
```

#### Skips

JSON input is preprocessed like MarkDown input, but the skips available are no the same.
This table summarize all the skips available:

 Delimiters     Place   Macro expansion     Delimiters removed  Content removed
-------------   -----   ---------------     ------------------  ---------------
`\\n`[^2]       Text    No                  Yes                 There is no content
`/*` `*/`       Text    No                  Yes                 Yes
`//` `\n`[^1]   Text    No                  Yes                 Yes
`"` `"`         Text    Yes                 No                  No

Table: **Semantics for all JSON skips**

[^1]: This represents a newline character.
[^2]: A backslash followed by a newline is treated as a line continuation (that
is, the backslash and the newline are removed and effectively ignored).

## Other utilities

When preparing metadata sometimes you need to mix files in several formats, or you
want to apply to YAML input queries in the _jq_ style.

### Format conversion

To make easy integrate metadata from several sources _jqt_ comes with the
following utilities to convert between CSV, JSON and YAML formats:

* `csv2json`
* `csv2yaml`
* `json2csv`
* `json2yaml`
* `yaml2csv`
* `yaml2json`

The utilities are filters that read standard input or a file passed as an
argument and write to standard output.

### Querying YAML and CSV

Also, sometimes you want to apply queries in the _jq_ style to CSV or YAML files.
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
