# Conventions

## Extension conventions for content files

The files in the `content` and `data` directories must follow some conventions in the file
extensions:

* Web site pages
    - `content/content.md`
    - `content/data.md`
    - `content/engine.md`
    - `content/index.md`
    - `content/structure.md`

* Partial MarkDown to be included
    - `content/EXAMPLE.text`
    - `content/FLOW.text`
    - `content/LINKS.text`
    - `content/opt/\*.text`

* Other unrelated MarkDown files
    - `content/help.text`
    - `content/jqt.1.text`

* Extension conventions for data files
    - `data/table.csv`
    - `data/snippets.md`
    - `data/document.json`
    - `data/document.yaml`

# Variables

Capitalized names are for global predefined variables.

## Site variables

All members defined in the configuration file, except `defaults`, and the
predefined variables:

* `.site.Assets`
* `.site.Blocks`
* `.site.Content`
* `.site.Data`
* `.site.Destination`
* `.site.Layouts`
* `.site.Metadata`
* `.site.Styles`

In the configuration file you can assign new values to all predefined variables
except `Metadata`, with hardcoded value in the file `Makefile`.

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

<!--
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
-->
