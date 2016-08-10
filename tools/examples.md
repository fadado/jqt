# Tests


# Examples


### Expressions


#### Test expr-01


**Template**:

```
The value of pi is {{.pi}}.
```

**JSON input**:

```
{ "pi": 3.14159265359 }
```

**Output generated**:

```
The value of pi is 3.14159265359.
```

#### Test expr-02


**Template**:

```
<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml'{{
        if .lang
        then " lang='"+.lang+"' xml:lang='"+.lang+"'"
        else "" end
}}>
```

**JSON input**:

```
{ "lang": "en_US" }
```

**Output generated**:

```
<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml' lang='en_US' xml:lang='en_US'>
```

#### Test expr-03


**Template**:

```
<html lang='{{.lang}}'>
<head>
  <title>{{.title}}</title>
</head>
```

**JSON input**:

```
{ 
  "lang": "en_GB",
  "title": "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..." 
}
```

**Output generated**:

```
<html lang='en_GB'>
<head>
  <title>Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...</title>
</head>
```

#### Test expr-51


**Template**:

```
{%.pi%}The value of pi is {{.}}.
```

**JSON input**:

```
{ "pi": 3.14159265359 }
```

**Output generated**:

```
The value of pi is 3.14159265359.
```

#### Test expr-52


**Template**:

```
<!DOCTYPE html>
<html>
  <head>
    <title>{{.variable | @html}}</title>
  </head>
  <body>
{{ .item_list | map("    "+@text) | join(",\n") }}
  </body>
</html>
```

**JSON input**:

```
{
  "variable": "Value with <unsafe> data",
  "item_list": [1, 2, 3, 4, 5, 6]
}
```

**Output generated**:

```
<!DOCTYPE html>
<html>
  <head>
    <title>Value with &lt;unsafe&gt; data</title>
  </head>
  <body>
    1,
    2,
    3,
    4,
    5,
    6
  </body>
</html>
```

### Conditionals


#### Test cond-01


**Template**:

```
<meta name='published' content='{{.published//empty}}' />
<meta name='updated' content='{{.updated//empty}}' />
```

**JSON input**:

```
{ "updated": "2016-06-26" }
```

**Output generated**:

```
<meta name='updated' content='2016-06-26' />
```

#### Test cond-02


**Template**:

```
<div>
    {% true//empty %}
	yay
    {% end %}
</div>
```

**Output generated**:

```
<div>
	yay
</div>
```

#### Test cond-03


**Template**:

```
<div>
	{{if true then "yay" else "" end}}
</div>
```

**Output generated**:

```
<div>
	yay
</div>
```

#### Test cond-51


**Template**:

```
{% .published//empty | $M %}
	<meta name='published' content='{{.published}}' />
{% end %}
{% .updated//empty %}
	<meta name='updated' content='{{.}}' />
{% end %}
```

**JSON input**:

```
{ "updated": "2016-06-26" }
```

**Output generated**:

```
	<meta name='updated' content='2016-06-26' />
```

### Loops


#### Test loop-01


**Template**:

```
<meta name='author' content='{{.author[]}}' />
```

**JSON input**:

```
{ "author": ["Anonymous", "Unknow"] }
```

**Output generated**:

```
<meta name='author' content='Anonymous' />
<meta name='author' content='Unknow' />
```

#### Test loop-51


**Template**:

```
{% .author | sort[] %}<meta name='author' content='{{.}}' />
```

**JSON input**:

```
{
  "author": ["Anonymous", "Unknow"]
}
```

**Output generated**:

```
<meta name='author' content='Anonymous' />
<meta name='author' content='Unknow' />
```

#### Test loop-52


**Template**:

```
<ul>
  {% range(.n) %}
  	<li>{{.}}</li>
  {% end %}
</ul>
```

**JSON input**:

```
{ "n": 4 }
```

**Output generated**:

```
<ul>
  	<li>0</li>
  	<li>1</li>
  	<li>2</li>
  	<li>3</li>
</ul>
```

#### Test loop-53


**Template**:

```
{% range(.n) %}
{{.}}
{% end %}
```

**JSON input**:

```
{ "n": 4 }
```

**Output generated**:

```
0
1
2
3
```
