---
<%include "site.yaml">
title: Templates syntax
updated: "2016-08-13T07:48:26Z"
---
<%include "site.m">&
<%include "LINKS.md">&

### Main _jqt_ features

* Each line of text in the template is a generator.
* Interpolation of expressions using the `{{...}}` syntactic sugar.
* Statements with _jq_ code inside `{%...%}`.
* One line statements begin with optional space and `{%...%}`. The rest of the
  line is in the nested block.
* Multiline blocks begin with optional space and `{%...%}`.
* Multiline blocks finish with optional space and `{% end %}`.
* Raw blocks are enclode between `{% raw %}` and `{%%}` marks.
* The input metadata provided to _jq_ is available in the dot (`.`) and the global variable `M$`.

## Processing

### Preprocessing

### Execution by `jq`

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
