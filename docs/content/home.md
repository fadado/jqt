---
<%include "config.yaml">
updated: "2016-08-17T09:55:33Z"
---
<%include "macros.m">&
<%include "LINKS.md">&

Could be [_jq_][JQ] the basis for a web template engine?
Let's explore&hellip;

## _jq_

_jq_ have nice features as string interpolation and implicit backtracking.
Mixed with the help of some syntactic sugar a powerful template engine appear.
Imagine the following simple strings, in the middle of a _jq_ program,
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
for a template language. We need some syntactic sugar, and this is provided to you by
_jqt_: you write templates in a very fashionable style, the templates
are translated into a _jq_ script and then `jq` is feed with the created
script and some metadata and content in [YAML][YAML] or [JSON][JSON] format&hellip; and the magic is done!

### Syntactic sugar

And, how do the _syntactic sugar_ looks like?  Do you think the following
example seems to be a template?

<%include "EXAMPLE.md">&

### Status

If you want to learn to use _jqt_,  [read this documentation][JQT]
and [install _jqt_](./engine.html#installation).
_jqt_ is developed under the _Fedora_ Linux
distribution, and a lot of portability issues are expected at this stage of
development. Please, use the project [GitHub repository][REPO] features if you
want to collaborate or send any kind of questions.

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
