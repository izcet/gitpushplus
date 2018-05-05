#!/bin/bash

GIT_COMMIT_MESSAGE=""
TEMP_FILE="/tmp/.gpp_commit" 

function on_exit {
    rm -rf $TEMP_FILE*
}
trap on_exit EXIT

git status  > $TEMP_FILE

# prevent adding changed files to commit message if they aren't in the commit itself
TARGET="Changes not staged for commit:"

if [ -n "$(grep "^$TARGET$" $TEMP_FILE)" ] ; then
    TEMP_TWO=${TEMP_FILE}_swp
    while read line ; do
        if [ "$line" == "$TARGET" ] ; then
            break
        fi
        echo "$line" >> $TEMP_TWO
    done < $TEMP_FILE
    mv $TEMP_TWO $TEMP_FILE
fi

# add_files_by_type <match type> <character type>
function add_files_by_type () {
    MATCH="$1"
    CHAR="$2"
    SUB_TEMP="${TEMP_FILE}_$MATCH"
    MESSAGE=""

    grep "$MATCH:" $TEMP_FILE | sed "s/.*$MATCH:\s*//" > "$SUB_TEMP"
    while read line ; do
        MESSAGE="${CHAR}[${line}] $MESSAGE"
    done < "$SUB_TEMP"

    echo "$MESSAGE"
}

# Deleted files are included in the commit message as -[delted/file]
GIT_COMMIT_MESSAGE="$(add_files_by_type "deleted" "-") $GIT_COMMIT_MESSAGE"

# New files are included in the commit message as +[new/file]
GIT_COMMIT_MESSAGE="$(add_files_by_type "new file" "+") $GIT_COMMIT_MESSAGE"

# Renamed files are included in the commit message as [old/file -> new/file]
GIT_COMMIT_MESSAGE="$(add_files_by_type "renamed" "") $GIT_COMMIT_MESSAGE"

# Modified files are included in the commit message as [file]
GIT_COMMIT_MESSAGE="$(add_files_by_type "modified" "") $GIT_COMMIT_MESSAGE"


# The final output is in LIFO order, such that
# [edited] [moved -> renamed] +[newfile] -[deleted]

if [ -n "$1" ] ; then
    GIT_COMMIT_MESSAGE="$@ $GIT_COMMIT_MESSAGE"
fi

# "optional custom commit message [edited] [moved -> renamed] +[newfile] -[deleted]"

echo "$GIT_COMMIT_MESSAGE"
