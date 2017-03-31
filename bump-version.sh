#!/bin/bash

# works with a file called VERSION in the current directory,
# the contents of which should be a semantic version number
# such as "1.2.3"

# this script will display the current version, automatically
# suggest a "minor" version update, and ask for input to use
# the suggestion, or a newly entered value.

# once the new version number is determined, the script will
# pull a list of changes from git history, prepend this to
# a file called CHANGES (under the title of the new version
# number) and create a GIT tag.

PUSH=${1:-No}

if [[ -f VERSION ]]; then
    declare -r CURRENT_VERSION=$(<VERSION)
    echo 1>&2 "Current version : $CURRENT_VERSION"
    set -- ${CURRENT_VERSION//./ }
    declare -i V_MAJOR=$1 V_MINOR=$2 V_PATCH=$3
    V_MINOR+=1
    V_PATCH=0
    declare -r SUGGESTED_VERSION="$V_MAJOR.$V_MINOR.$V_PATCH"
    read 1>&2 -p "Enter a version number [$SUGGESTED_VERSION]: "
    [[ -z $REPLY ]] && NEXT_VERSION=$SUGGESTED_VERSION
    echo 1>&2 "Will set new version to be $NEXT_VERSION"
    echo -n $NEXT_VERSION > VERSION
    {   echo "Version $NEXT_VERSION:"
        git log --pretty=format:" - %s" "v$CURRENT_VERSION"...HEAD
        echo -e '\n'
        cat CHANGES
    } > /tmp/$$-changes
    cp /tmp/$$-changes CHANGES
    rm /tmp/$$-changes
    git add CHANGES VERSION
    sed -i "s/^declare -r VERSION=/&'$NEXT_VERSION'"
    git commit -m "Version bump to $NEXT_VERSION"
    git tag -a -m "Tagging version $NEXT_VERSION" "v$NEXT_VERSION"
    [[ $PUSH == yes ]] && git push origin --tags
else
    echo 1>&2 'Could not find a VERSION file'
    read 1>&2 -p 'Create a new VERSION file [y/yes]? '
    case $REPLY in
    ''|[Yy]|[Yy][Ee][Ss])
        echo -n '0.1.0' > VERSION
        {   echo 'Version 0.1.0'
            git log --pretty=format:' - %s'
            echo -e '\n'
        } >> CHANGES
        git add VERSION CHANGES
        git commit -m 'Added VERSION and CHANGES files, version bump to v0.1.0'
        git tag -a -m 'Tagging version 0.1.0' 'v0.1.0'
        [[ $PUSH == yes ]] && git push origin --tags
        ;;
    *) echo 1>&2 'Ok'
        ;;
    esac
fi

exit

# vim:ai:sw=4:ts=4:et:syntax=sh
