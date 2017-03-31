# _jqt_ · The _jq_ template engine

_jqt_ is a web template engine that uses [_jq_](https://stedolan.github.io/jq/) as expression language.

If you want to learn to use _jqt_, read the documentation at
<https://fadado.github.io/jqt/>. The documentation is generated using _jqt_ in the `docs`
folder of this repository.

The tools used in the implementation of _jqt_ are:

* [jq](https://stedolan.github.io/jq/), a lightweight and flexible command-line JSON processor.
* [GPP](https://logological.org/gpp), a general-purpose preprocessor.
* [Pandoc](http://pandoc.org/), a universal document converter.
* [Bash](https://www.gnu.org/software/bash/), [sed](https://www.gnu.org/software/sed/) and other shell tools.

If you are interested in _jq_ you can see also [JBOL](https://fadado.github.io/jbol/),
a related project with a collection of modules for the _jq_ language.

_jqt_ is developed under the _Fedora_ Linux distribution, and a lot of
portability issues are expected at this stage of development. Please, use this
GitHub repository features if you want to send any kind of questions.

## Project management

This project uses [GNU Make](https://www.gnu.org/software/make/) on several
development activities, but `make` is not necessary to run `jqt`. This section explains
the repository structure and how it is managed.

### Makefile

The file `Makefile` concentrates all the routine procedures, like running the tests
or install last versions of scripts in the system directories. The main defined _targets_
are:

* `check`: run the _jqt_ tests. This is the default target.

* `clean`: remove all files generated during tests execution.

* `install`: install _jqt_ scripts and related files in the system directories.

* `uninstall`: remove installed files from the system directories.

* `help`:  list all targets defined in the Makefile.

### Scripts

The `bin` directory contains `jqt` and other related tools. The `jqt` script
also needs some files located in the [`share`](./share/) directory.

### Tests

The execution of `make check` or simply `make` will run several tests located in the directory
[`tests`](./tests/). Ensure that the tests are passed before start
another `jqt` uses.

### Documentation

The directory [`docs`](./docs/) contains the documentation for _jqt_, and is in itself a subproject with his
own makefile. Please see the directory [`docs`](./docs/) for all information on
this subproject.

<!--
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=markdown
-->
