---
layout: default
title: Welcome to jqt
description: Could be jq the basis for a web template engine?
keywords:  jqt, jq, template engine
updated: "2016-08-28T10:27:09Z"
---
<%include macros/markup.m>&
<%include content/LINKS.txt>&

# Welcome

> _Editing is a rewording activity._\
> — _Alan J. Perlis_

Could be [_jq_][JQ] the basis for a web template engine?
Let’s explore&hellip;

## _jq_

[_jq_][JQ] have nice features like string interpolation and implicit backtracking.
Mixed with the help of some syntactic sugar a powerful template engine appear.
Imagine the following interpolation strings, in a [_jq_][JQ] program,
separated with the comma operator:

### Simple expansion

```html
..., "<title>\(.title)</title>", ...
```

### Conditional expansion

```html
..., "<meta name='date' content='\(.published//empty)' />", ...
```

### Repeated expansion

```html
..., "<meta name='author' content='\(.author[])' />", ...
```

In these examples the strings expand, vanish, or multiply without any
explicit `if` or `for`!

## _jqt_

To write [_jq_][JQ] scripts using strings with interpolations is not the idea we have
for a template language. We need some syntactic sugar, and this is provided by
_jqt_: you write templates in a very fashionable style, the templates
are translated into a [_jq_][JQ] script and then `jq` is feed with the created
script and some content and data in [JSON][JSON] format&hellip; and the magic is done!

### Syntactic sugar

And, how do the _syntactic sugar_ looks like?  Do you think the following
example seems to be a template?

<%include content/EXAMPLE.txt>&

### Status

This site is built using _jqt_, and is itself in his implementation a kind of
tutorial about _jqt_.

If you want to learn how to use _jqt_ [install it](./engine.html#installation) and
see all the different sections of this site:

* [Template engine](./engine.html)
* [Page structure](./structure.html)
* [Authoring content](./content.html)
* [Data model](./data.html)

And don’t forget to study this site source code in the repository
[`docs` directory](https://github.com/fadado/jqt/tree/master/docs)!

_jqt_ is developed under the _Fedora_ Linux
distribution, and a lot of portability issues are expected at this stage of
development. Please, use the project [GitHub repository][REPO] features if you
want to collaborate or send any kind of questions.

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
