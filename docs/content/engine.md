---
<%include "config.yaml">
title: Operating the engine
updated: "2016-08-17T09:50:11Z"
---
<%include "macros.m">&
<%include "LINKS.MD">&

## General operation

_jqt_ orchestrates several shell utilities to transform [MarkDown][MARKDOWN] text and
[YAML][YAML] or [JSON][JSON] data into a final HTML document. The transformation is driven by a template,
where HTML is mixed with [_jq_][JQ] snippets to implement the transformation logic.
This diagram shows how document, template and data inputs (on the left) are combined by
_jqt_ to produce the final HTML output:

<%include "FLOW.MD">

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

| **jqt** [**-h** | **--help** | **-p** | **-V** | **--version**]
| **jqt** [_options_] < _infile_ > _result_
| **jqt** [_options_] _infile_ > _result_
| **jqt** [_options_] _infile_ _result_

### Options

<%include "opt/4.md">
<%include "opt/C.md">
<%include "opt/D.md">
<%include "opt/d.md">
<%include "opt/e.md">
<%include "opt/f.md">
<%include "opt/H.md">
<%include "opt/h.md">
<%include "opt/I.md">
<%include "opt/i.md">
<%include "opt/j.md">
<%include "opt/L.md">
<%include "opt/M.md">
<%include "opt/m.md">
<%include "opt/n.md">
<%include "opt/P.md">
<%include "opt/p.md">
<%include "opt/r.md">
<%include "opt/S.md">
<%include "opt/T.md">
<%include "opt/t.md">
<%include "opt/V.md">

## Preprocessing

One distinctive feature of _jqt_ is the text expansion applied to almost
all kind of input files.
Also, _jqt_ can be used as a standalone
preprocessor thanks to the `-P` option.

### Kinds of preprocessing

The sections about
[templates](./structure.html#preprocessing),
[documents](./content.html#preprocessing) and [data](./data.html#json) cover in
detail their usage of the preprocessor.

A different transformation can also be be considered a kind of preprocessing. The option
`-T` allows the use of YAML files for collections of MarkDown snippets:

<%include "opt/T.md">

### CSS preprocessing

As a bonus, _jqt_ can also expand CSS style sheets.  This is documented in this
section because it is outside the _jqt_ normal processing work flow.

To enable CSS preprocessing the `-P` option must be used with the `css` or `css-min` options:

<%include "opt/P.md">

You can minify the CSS style sheet choosing the `css-min` option.
The CSS minimization is not extremely aggressive, but is safe and sufficient.

#### Macro calls

The macro syntax used by _jqt_ in CSS files is very similar to used by the traditional
`cpp` preprocessing of C and C++ languages, but changing the prefix character `#` by
`&`.
The more common predefined macros have this syntax:

```
&defeval x y
&define x y
&elif expr
&else
&endif
&eval expr
&if expr
&ifdef x
&ifeq x y
&ifndef x
&ifneq x y
&include file
&undef x
```

Inside macro definitions argument references are prefixed by a dollar (`$1`, `$2`, etc.).
The more common used features are the inclusion on external files and definition of simple constants:

```
&include "theme.css"

&define Blue #0000FF

{ color: &Blue; }
```

Warning: you must read the [GPP manual][GPPMAN] if you want to know all the gory details.

#### Skips

The main use of the preprocessor is to remove comments in the CPP style:

```
/* Block comments */
// Line comments
```

Quoted strings are also defined as skips, and backticks can be used to
disable macro expansion (inside double quoted strings backticks are ignored).
This table summarizes all the available skips in JSON files:

 Delimiters         Macro expansion     Delimiters removed  Content removed
-------------       ---------------     ------------------  ---------------
`&\n`[^1]           No                  Yes                 There is no content
`/*` `*/`           No                  Yes                 Yes
`//` `\n`[^2]       No                  Yes                 Yes
`` ` `` `` ` ``     No                  Yes                 No
`"` `"`             No                  No                  No
`'` `'`             No                  No                  No

Table: **Semantics for all CSS skips**

[^1]: An ampersand followed by a newline is treated as a line continuation (that
is, the ampersand and the newline are removed and effectively ignored).
[^2]: This represents a newline character.

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
