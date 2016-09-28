---
title: Welcome
updated: "2016-08-28T10:27:09Z"
---
<%include macros.m>&
<%include content/LINKS.txt>&

> _Editing is a rewording activity._\
> — _Alan J. Perlis_

Could be [_jq_][JQ] the basis for a web template engine?
Let's explore&hellip;

## _jq_

_jq_ have nice features like string interpolation and implicit backtracking.
Mixed with the help of some syntactic sugar a powerful template engine appear.
Imagine the following simple strings, in a _jq_ program,
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

To write _jq_ scripts using strings with interpolations is not the idea we have
for a template language. We need some syntactic sugar, and this is provided by
_jqt_: you write templates in a very fashionable style, the templates
are translated into a _jq_ script and then `jq` is feed with the created
script and some content and data in [JSON][JSON] format&hellip; and the magic is done!

### Syntactic sugar

And, how do the _syntactic sugar_ looks like?  Do you think the following
example seems to be a template?

<%include content/EXAMPLE.txt>&

### Status

This site is built using _jqt_, and is itself in his implementation a kind of
tutorial about _jqt_.

<details>

<summary>
If you want to learn to use _jqt_ [install _jqt_](./engine.html#installation) and
read all the different site sections:
</summary>

* [Template engine](./engine.html)
* [Page structure](./structure.html)
* [Authoring content](./content.html)
* [Data model](./data.html)

And don't forget to study the source code under the [docs directory](https://github.com/fadado/jqt/tree/master/docs)!

</details>

_jqt_ is developed under the _Fedora_ Linux
distribution, and a lot of portability issues are expected at this stage of
development. Please, use the project [GitHub repository][REPO] features if you
want to collaborate or send any kind of questions.

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
