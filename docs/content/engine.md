---
<%include "config.yaml">
title: Operating the engine
updated: "2016-08-17T09:50:11Z"
---
<%include "macros.m">&
<%include "LINKS.md">&

## General operation

_jqt_ orchestrates several shell utilities to transform [MarkDown][MARKDOWN] text and
[YAML][YAML] or [JSON][JSON] data into a final HTML document. The transformation is driven by a template,
where HTML is mixed with [_jq_][JQ] snippets to implement the transformation logic.
This diagram shows how document, template and metadata inputs (on the left) are combined by
_jqt_ to produce the final HTML output:

<%include "FLOW.md">

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
install it by hand executing a few orders on the _jqt_ top directory:

```zsh
$ sudo mkdir -p /usr/local/bin /usr/local/share/jqt
$ sudo cp bin/* /usr/local/bin
$ sudo cp share/* /usr/local/share/jqt
$ [[ $PATH =~ /usr/local/bin ]] || echo 'You must edit your PATH'
```

If you know how to use `make` please read the `Makefile` located in the _jqt_
top directory and run `make install` if you agree with the things that will
happen. You can also change the installation directory:

```zsh
$ sudo make install prefix=/your/installation/path
```

But if you choose a directory different of `/usr/local/share` for the shared data
you must still edit the parameter `DATADIR` definition in the `bin/jqt` file.

## Invoking _jqt_

### Synopsis

`jqt` accepts several options and can be called with zero, one or two file
arguments.  The usage possibilities are:

| **jqt** [_options_] < _infile_ > _result_
| **jqt** [_options_] _infile_ > _result_
| **jqt** [_options_] _infile_ _result_

### Options

#### Preprocessor options

<%include "opt/D.md">
<%include "opt/I.md">

#### Document options

<%include "opt/4.md">
<%include "opt/d.md">
<%include "opt/n.md">

#### Template options

<%include "opt/i.md">
<%include "opt/j.md">
<%include "opt/L.md">

#### Metadata options

<%include "opt/f.md">
<%include "opt/M.md">
<%include "opt/m.md">

#### Debugging options

<%include "opt/C.md">
<%include "opt/E.md">
<%include "opt/H.md">
<%include "opt/P.md">
<%include "opt/S.md">

#### Information options

<%include "opt/h.md">
<%include "opt/p.md">
<%include "opt/V.md">

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
