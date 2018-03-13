#!/bin/bash

GIT_COMMIT_MESSAGE=""
TEMP_FILE="/tmp/.gpp_commit.tmp" 

function on_exit {
    rm -rf $TEMP_FILE
}
trap on_exit EXIT

# Deleted files are included in the commit message as -[delted/file]
git status | grep "deleted:" | sed 's/.*deleted:....//' > $TEMP_FILE
while read line ; do
    GIT_COMMIT_MESSAGE="-[$line] $GIT_COMMIT_MESSAGE"
done < $TEMP_FILE


# New files are included in the commit message as +[new/file]
git status | grep "new file:" | sed 's/.*new file:...//' > $TEMP_FILE
while read line ; do
    GIT_COMMIT_MESSAGE="+[$line] $GIT_COMMIT_MESSAGE"
done < $TEMP_FILE


# Renamed files are included in the commit message as [old/file -> new/file]
git status | grep "renamed:" | sed 's/.*renamed:....//' > $TEMP_FILE
while read line ; do
    GIT_COMMIT_MESSAGE="[$line] $GIT_COMMIT_MESSAGE"
done < $TEMP_FILE


# Modified files are included in the commit message as [file]
git status | grep "modified:" | sed 's/.*modified:...//' > $TEMP_FILE
while read line ; do
    GIT_COMMIT_MESSAGE="[$line] $GIT_COMMIT_MESSAGE"
done < $TEMP_FILE


# The final output is in LIFO order, such that
# [edited] [moved -> renamed] +[newfile] -[deleted]

if [ -n "$1" ] ; then
    GIT_COMMIT_MESSAGE="$@ $GIT_COMMIT_MESSAGE"
fi

# "optional custom commit message [edited] [moved -> renamed] +[newfile] -[deleted]"

echo "$GIT_COMMIT_MESSAGE"
