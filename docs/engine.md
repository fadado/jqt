---
<%include "config.yaml">
title: Template engine
updated: "2016-08-05T09:15:11Z"
---

<%include "macros.m">&

## <%cite jq> templates

The <%cite jq> template language will be called <%cite jqt>.  The tools used in the
implementation of <%cite jqt> are:

* [jq](https://stedolan.github.io/jq/), a lightweight and flexible command-line JSON processor.
* [Bash](https://www.gnu.org/software/bash/), [sed](https://www.gnu.org/software/sed/) and other shell tools.
* [GNU Make](https://www.gnu.org/software/make/), the tool that builds executable programs and libraries from source code.
* [GPP](https://logological.org/gpp), a general-purpose preprocessor.
* [Pandoc](http://pandoc.org/), a universal document converter.

Template engine components

### Flow


```
           jqt        +------+   +-------+  jq
Template +----------->|expand|-->|convert|-------------------------------+
                      +------+   +-------+                               |
                                                                         |
                                               HTML                      | 
                                               fragment                  v
           MarkDown   +------+   +------+   /-------->+-----+  JSON   +------+
Document +----------->|expand|-->|markup|--+          |merge|-------->|render|--> HTML
                      +------+   +------+   \-------->+-----+         +------+
                                               YAML    ^   ^
                                          front-matter |   |
                                                       |   |
           JSON       +------+                         |   |
         +----------->|expand|-------------------------+   |
Metadata              +------+                             |
         +-------------------------------------------------+
           YAML   
```

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
