---
<%include "site.yaml">
title: Template engine
updated: "2016-08-13T07:48:26Z"
---
<%include "site.m">&
<%include "LINKS.md">&

## <%cite jq> templates

The <%cite jq> template language will be called <%cite jqt>.  The tools used in the
implementation of <%cite jqt> are:

* [jq][JQ], a lightweight and flexible command-line JSON processor.
* [Bash](https://www.gnu.org/software/bash/), [sed](https://www.gnu.org/software/sed/) and other shell tools.
* [GNU Make](https://www.gnu.org/software/make/), the tool that builds executable programs and libraries from source code.
* [GPP][GPP], a general-purpose preprocessor.
* [Pandoc][Pandoc], a universal document converter.

Template engine components

<# Printed in all pages #>
<%include "FLOW.md">

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
