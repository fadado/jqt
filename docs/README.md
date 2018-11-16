# Conventions

## Extension conventions for content files

The files in the `content` directory must follow some conventions in the file
extensions:

* `*.md`: Web site pages.
* `*.text`: Partial MarkDown to be included and other unrelated MarkDown files.

The files in the `data` directory must follow some conventions in the file
extensions:

* `*.md`: MarkDown snippets in front-matter.
* `*.csv`: CSV data files.
* `*.json`: JSON documents.
* `*.yaml`: YAML documents.

# Variables

Capitalized names are for global predefined variables.

## Site variables

All members defined in the configuration file, except `defaults`, and the
predefined variables:

* `.site.Assets`
* `.site.Blocks`
* `.site.Content`
* `.site.Data`
* `.site.Root`
* `.site.Layouts`
* `.site.Meta`
* `.site.Styles`

In the configuration file you can assign new values to all predefined variables
except `Meta`, with default value defined in the file `make.d/Makefile.make`.
You can modify this variable at the very beggining of your `Makefile`.

## Page variables

Front-matter members and the predefined variables.

### Read only variables

* `.page.Base`
* `.page.Date`
* `.page.Filename`
* `.page.Id`
* `.page.Layout`
* `.page.Path`
* `.page.Section`
* `.page.Slug`
* `.page.Source`
* `.page.URL`

### Variables merged with defaults

* `.page.Datasets`
* `.page.Dependencies`
* `.page.Flags`

### Source for pathname related variables

```
          Slug
        |---^---|
content/name.html
        |-^|
         Id

        Section  Slug
        |--^-| |--^----|
content/extras/name.html
        |-------v-|
        |--v--| Id
          Path

            Section      Slug
        |------^-----| |---^---|
content/extras/indexes/name.html
        |---------------v-|
        |-----v-------| Id
             Path
```

# _Sake_: static site build automation system

## Current _GMake_ commands

```
Usage: make TARGET [parameter=value...]
Targets:
    build       clobber         h5.lint     list
    clean       configure       h5.valid    touch
```

<!--
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
-->
