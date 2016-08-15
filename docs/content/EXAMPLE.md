<#
 # Template example
 #>

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

<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
#>
