---
<%include "site.yaml">
title: Operating the engine
updated: "2016-08-13T07:48:26Z"
---
<%include "site.m">&
<%include "LINKS.md">&

## General operation

<%cite jqt> orchestrates several shell utilities to transform MarkDown text and
YAML or JSON data into a final HTML document. The transformation is driven by a template,
where HTML is mixed with <%cite jq> snippets to implement the transformation logic.
This diagram shows how document, template and metadata inputs are combined by
<%cite jqt> to produce the final HTML output.

<%include "FLOW.md">

## The `jqt`command

### Syntax

`jqt` accepts several options and can be called with zero, one or two file
arguments.  As the output of `jqt --help` shows, the usage possibilities are:

```
Usage: jqt [options] < infile > result
       jqt [options] infile > result
       jqt [options] infile result
```

### Options

#### Preprocessor options

-D NAME=VAL

:   Define the user macro *NAME* as equal to *VAL*.

-I DIRECTORY

:   Append *DIRECTORY* to the end of the preprocessor list of directories to be
searched for include files.


#### Template options

-L DIRECTORY

:   Append *DIRECTORY* to the end of the jq list of directories to be searched
for included and imported modules.

-i MODULE

:   Include the jq *MODULE* in the render stage.

-j MODULE:NAME

:   Import the jq *MODULE* in the render stage.

#### Document options

-4, -5

:   Set output HTML version (HTML4 / HTML5).

-d FILE

:   Read content document from *FILE*.

-p

:   Print list of Pandoc accepted options.

#### Metadata options

-M NAME:FILE

:   Add a *FILE* in JSON or YAML format to the input metadata at the top level
(*NAME* is ignored but must be present and unique).

-m NAME:FILE

:   Add a *FILE* in JSON or YAML format to the input metadata as a value of object *NAME*.

#### Debugging options

-C

:   Stops processing before the render stage (outputs full JSON data model).

-E

:   Stops template processing after the preprocessing stage (outputs the
expanded template).

-H

:   Stops MarkDown processing after generating HTML (outputs several HTML fragments).

-P

:   Stops MarkDown processing after preprocessing stage (outputs the expanded
MarkDown).

-S

:   Stops template processing before the render stage (outputs the jq script).

## Implementation

The main tools used by <%cite jqt> are:

* [Bash](https://www.gnu.org/software/bash/), [sed](https://www.gnu.org/software/sed/) and other shell tools.
* [GPP][GPP], a general-purpose preprocessor.
* [jq][JQ], a lightweight and flexible command-line JSON processor.
* [Pandoc][PANDOC], a universal document converter.

The command `jqt` is an script executed by `bash`. The external shell commands
called by `jqt` are:

* `cat`
* `gpp`
* `jq`
* `mkdir`
* `mkfifo`
* `pandoc`
* `python` (with `json` and `yaml` modules)
* `rm`
* `sed`
* `sleep`
* `tee`

## Installation

...

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
