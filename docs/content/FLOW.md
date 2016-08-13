<#
 # Flow diagram shared in all pages
 #>

## Flow diagram

This diagram shows how document, template and metadata inputs are combined by
<%cite jq> to produce the final HTML output.


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
