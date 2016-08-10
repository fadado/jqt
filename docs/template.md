---
<%include "config.yaml">
title: Templates syntax
updated: "2016-08-05T09:15:11Z"
---

<%include "macros.m">&

### Features

* Each line of text in the template is a generator.
* Interpolation of expressions using the `{{...}}` syntactic sugar.
* Statements with <%cite jq> code inside `{%...%}`.
* One line statements begin with optional space and `{%...%}`. The rest of the
  line is in the nested block.
* Multiline blocks begin with optional space and `{%...%}`.
* Multiline blocks finish with optional space and `{% end %}`.
* Raw blocks are enclode between `{% raw %}` and `{%%}` marks.
* The input metadata provided to <%cite jq> is available in the dot (`.`) and the global variable `M$`.

### Limitations

You must be careful writing templates.

* Multiline block start cannot have any suffix text after `{%...%}`.
* The error messages are wrong referencing the lines where the problems happens.

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
