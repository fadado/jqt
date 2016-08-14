---
<%include "site.yaml">
title: Operating the engine
updated: "2016-08-13T07:48:26Z"
---
<%include "macros.m">&
<%include "LINKS.md">&

## General operation

_jqt_ orchestrates several shell utilities to transform MarkDown text and
YAML or JSON data into a final HTML document. The transformation is driven by a template,
where HTML is mixed with _jq_ snippets to implement the transformation logic.
This diagram shows how document, template and metadata inputs are combined by
_jqt_ to produce the final HTML output.

<%include "FLOW.md">

## Invoking _jqt_

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

:   Add a *FILE* in YAML or JSON format to the input metadata at the top level
(*NAME* is ignored but must be present and unique).

-m NAME:FILE

:   Add a *FILE* in YAML or JSON format to the input metadata as a value of object *NAME*.

#### Debugging options

-E

:   Stops template processing after the preprocessing stage (outputs the
expanded template).

    ```
    $ jqt -E layouts/footer.html 
    <div style="text-align:center;">
    {{.snippets.footer}}
    </div>
    ...
    ```

-S

:   Stops template processing before the render stage (outputs the jq script).

    ```
    $ jqt -S docs/layouts/footer.html 
    import "libjqt" as jqt;
    . as $M |
    "<div style=\"text-align:center;\">",
    "  \(.snippets.footer)",
    "</div>",
    ...
    ```

-P

:   Stops MarkDown processing after preprocessing stage (outputs the expanded
MarkDown).

    ```
    $ jqt -P content/engine.md 
    ---
    title: jqt · the jq template engine
    baseURL: https://fadado.github.com/jqt/
    lang: en
    ---

    ## <cite>jq</cite> templates

    The <cite>jq</cite> template language will be called <cite>jqt</cite>.  
    The tools used in the implementation of <cite>jqt</cite> are:
    ```

-H

:   Stops MarkDown processing after generating HTML (outputs several HTML fragments).

    ```
    $ jqt -Icontent -H content/engine.md 
    <p>Could be <a href="https://stedolan.github.io/jq/"><em>jq</em></a> the
    basis for a web template engine? Let's explore…</p>
    <h2 id="jq"><em>jq</em></h2>
    ...
    ```

-C

:   Stops processing before the render stage (outputs full JSON data model).

    ```
    $ jqt -I layouts -C -d content/home.md layouts/default.html 
    {
        "body": "<!DOCTYPE html ...
        "front": {
            "front-matter": false,
            ...
        }
    }
    ```

## Implementation

The command `jqt` is a shell script executed by `bash`.
`jqt` has been tested with [Bash 4.3][BASH], [GNU sed 4.2][SED], [GPP 2.24][GPP],
[jq 1.5][JQ] and [Pandoc 1.13][PANDOC]. Also is used a small Python snippet which depends
on the modules `json` and `yaml`.

The project uses [GNU Make][MAKE] on several development activities, but `make`
is not necessary to run `jqt`.

All external shell commands called by `jqt` are:

* `cat`
* `gpp`
* `jq`
* `mkdir`
* `mkfifo`
* `pandoc`
* `python`
* `rm`
* `sed`
* `sleep`
* `tee`

Under a recent <%cite Fedora> <%cite Linux> distribution the following commands will install
all the extra software _jqt_ needs:

```zsh
$ sudo dnf -y install make general-purpose-preprocessor jq pandoc PyYAML
```

## Installation

If you know how to use `make` please read the `Makefile` located in the _jqt_
top directory and run `make install` if you agree with the thinks that will
happen. You can also change the installation directory:

```zsh
$ sudo make install prefix=/your/installation/path
```

You can also install _jqt_ by hand with few orders like:


```zsh
$ sudo mkdir -p /usr/local/bin /usr/local/share/jqt
$ sudo cp bin/jqt /usr/local/bin
$ sudo chmod +x /usr/local/bin/jqt
$ sudo cp share/* /usr/local/share/jqt
```

If you are using a recent <%cite Fedora> <%cite Linux> distribution or similar
`make` will also help you to install all the extra software _jqt_ needs:

```zsh
$ sudo make setup
```


<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
