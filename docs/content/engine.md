---
layout: page
title: The jqt template engine
description: jqt orchestrates several shell utilities to transform MarkDown text and YAML or JSON data into a final HTML page.
keywords:  jqt, jq, YAML, gpp, preprocessing, template engine
updated: "2016-08-28T10:27:09Z"
---
<%include macros.m>&
<%include content/LINKS.txt>&

# Template engine

As the [Wikipedia says](https://en.wikipedia.org/wiki/Template_processor),
<q><i>a template engine is
software designed to combine one or more templates with a data model to produce
one or more result documents</i></q>. _jqt_ fully satisfies this definition.

## Implementation

_jqt_ orchestrates several shell utilities to transform [MarkDown][MARKDOWN] text and
[YAML][YAML] or [JSON][JSON] data into a final HTML page. The transformation is driven by a template,
where HTML is mixed with [_jq_][JQ] snippets to implement the transformation logic.
This diagram shows how document, template and data inputs (on the left) are combined by
_jqt_ to produce the final HTML output:

<%include content/FLOW.txt>

The command `jqt` is a shell script executed by `bash`.
The external shell commands called by `jqt` are `cat`, `gpp`, `jq`, `mkdir`,
`mkfifo`, `pandoc`, `python`, `rm`, `sed`, `sleep` and `tee`.

`jqt` has been tested with [Bash 4.3][BASH], [GNU sed 4.2][SED], [GPP 2.24][GPP],
[jq 1.5][JQ] and [Pandoc 1.13][PANDOC]. A small Python snippet is used which depends
on the modules `json` (introduced with [Python 2.6](https://docs.python.org/2.6/))
and `yaml` ([PyYAML](http://pyyaml.org/) implementation).
The project uses [GNU Make][MAKE] on several development activities, but `make`
is not necessary to run `jqt`.

## Installation

Under a recent <%cite Fedora> <%cite Linux> distribution most of the commands
used by _jqt_ are installed by default. The following command will install all the extra
software _jqt_ needs:

```zsh
$ sudo dnf -y install make general-purpose-preprocessor jq pandoc PyYAML
```

After clone or [download](https://github.com/fadado/jqt/releases) _jqt_ you can
manually install it executing a few commands on the _jqt_ top directory:

```zsh
$ sudo mkdir -p /usr/local/bin /usr/local/share/jqt
$ sudo cp bin/* /usr/local/bin
$ sudo cp share/* /usr/local/share/jqt
$ [[ $PATH =~ /usr/local/bin ]] || echo 'Add /usr/local/bin to your PATH'
```

If you know how to use `make` please see the `Makefile` located in the _jqt_
top directory and run `make install` if you agree with the things that will
happen. You can also change the installation directory:

```zsh
$ sudo make install prefix=/your/installation/path
```

But if you choose a directory different of `/usr/local/share` for the shared data
you must still edit by hand the parameter `DATADIR` definition in the `bin/jqt` file.

## Invoking _jqt_

### Synopsis

`jqt` accepts several options and can be called with zero, one or two filename
arguments.  The usage possibilities are:

| **jqt** [**-h** | **--help** | **-p** | **-V** | **--version**]
| **jqt** [_options_] < _infile_ > _result_
| **jqt** [_options_] _infile_ > _result_
| **jqt** [_options_] _infile_ _result_

### Options

<%include content/opt/4.txt>
<%include content/opt/C.txt>
<%include content/opt/D.txt>
<%include content/opt/d.txt>
<%include content/opt/e.txt>
<%include content/opt/H.txt>
<%include content/opt/h.txt>
<%include content/opt/I.txt>
<%include content/opt/i.txt>
<%include content/opt/j.txt>
<%include content/opt/L.txt>
<%include content/opt/M.txt>
<%include content/opt/m.txt>
<%include content/opt/n.txt>
<%include content/opt/P.txt>
<%include content/opt/p.txt>
<%include content/opt/r.txt>
<%include content/opt/S.txt>
<%include content/opt/T.txt>
<%include content/opt/t.txt>
<%include content/opt/V.txt>
<%include content/opt/w.txt>

## Preprocessing

One distinctive feature of _jqt_ is the text expansion, using `gpp`, applied to almost
all kinds of input files.
Also, _jqt_ can be used as a standalone
preprocessor thanks to the `-P` option.

_jqt_ uses two different syntaxes for macros, one for
[_jqt_ templates](./structure.html#preprocessing) and
[MarkDown documents](./content.html#preprocessing)
and another for [JSON and CSS](./data.html#preprocessing) files. 
The following table summarizes the syntax of macro calls:

                            JQT and MarkDown    JSON and CSS
---------------             ----------------    ----------------
Macro calls                 `<%m>`              `&m`
                            `<%m x y>`          `&m{x}{y}`
Macro arguments             `$1`...`$9`         `$1`...`$9`
Interpolation in arguments  `" "`
Escapes in arguments        `' '`

Table: **Summary of macro syntax**

The following table summarizes the syntax of text skips:

                    JQT templates   MarkDown content        JSON documents  CSS stylesheets
------------------  -------------   ----------------        --------------  ---------------
Continuation lines  `&`             `&`                     `&`             `&`
Block comment       `<# #>`         `<# #>`                 `/* */`         `/* */`
Line comment                                                `//`            `//`
Verbatim copy       `<!-- -->`      `<!-- -->`
                                    `` ` ` ``
                                    `\n~~~` (also backticks)
Escape                                                      `` ` ` ``       `` ` ` ``
String              `{% %}`                                 `" "`           `" "`
                    `{{ }}`                                                 `' '`
                    `{# #}`

Table: **Summary of text skips**

<details>

<summary>
_jqt_ offers also a transformation that can also be considered a kind of preprocessing.
The option `-T` allows the use
of YAML files for collections of MarkDown snippets:
</summary>

<%include content/opt/T.txt>

</details>

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
