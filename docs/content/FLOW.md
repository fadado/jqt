<#
 # Flow diagram
 #>

```
           jqt        +------+   +-------+  jq script
Template +----------->|expand|-->|convert|-------------------------------+
                      +------+   +-------+                               |
                                                                         |
                                               HTML and CSS              | 
                                               fragments                 v
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
