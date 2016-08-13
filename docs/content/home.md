---
<%include "site.yaml">
updated: "2016-08-13T07:48:26Z"
---
<%include "site.m">&
<%include "LINKS.md">&

Could be [<%cite jq>][JQ] the basis for a web template engine?
Let's explore&hellip;

## <%cite 'jq'>

<%cite jq> have nice features as string interpolation and implicit backtracking.
Mixed with the help of some syntactic sugar a powerful template engine appear.
Imagine the following simple strings, in the middle of a <%cite jq> program,
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

## <%cite jqt>

To write <%cite jq> scripts using strings with interpolations is not the idea we have
for a template language. We need some syntactic sugar, and this is provided to you by
<%cite jqt>. You write templates in a very fashionable style, the templates
are translated into a <%cite jq> script and then `jq` is feed with the created
script and some metadata and content in JSON or YAML format&hellip; and the magic is done!

### Syntactic sugar

And, how do the _syntactic sugar_ looks like?  Do you think the following
example looks like a template?

```html
<html lang='{{.lang}}'>
<head>
    {# block comments #}
    <title>{{.title | gsub("<[^>]*>"; "")}}</title>
    <meta name='date' content='{{.updated//empty}}' />
    {# implicit loop if several authors #}
    {% .author | sort[] %}<meta name='author' content='{{.}}' />
    {# include files in preprocessing stage #}
    <%include "head.html">
</head>
<body>
    <h1>{{.title}}</h1>
    <h2>{{.subtitle//empty}}</h2> {# line vanishes if subtitle not defined #}
    <ul>
        {% range(.n) %} {# loop from 0 to .n-1 #}
            <li>{{.}}</li>
        {% end %}
    </ul>
</body>
</html>
```

### Status

If you want to learn to use _jqt_, read the documentation at
[https://fadado.github.io/jqt/][JQT].  _jqt_ is developed under the _Fedora_ Linux
distribution, and a lot of portability issues are expected at this stage of
development. Please, use the project [GitHub repository][REPO] features if you
want to collaborate or send any kind of questions.

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
