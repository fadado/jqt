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
                      +------+   +------+   \-------->+-----+         +------+    page
                                          YAML         ^   ^
                                          front-matter |   |
                                          metadata     |   |
           JSON       +------+                         |   |
         +----------->|expand|-------------------------+   |
    Data              +------+                             |
         +-------------------------------------------------+
           YAML                                            |
                                 +------+                  |
         +---------------------->|markup|------------------+
           YAML snippets         +------+
```

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
