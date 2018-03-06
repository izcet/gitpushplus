#!/bin/sh

GIT_COMMIT_MESSAGE=""
TEMPFILE=".git_temp_status.swp" # this temporary file is in the .gitignore
# It's named a swap file so as to be ignored even if it's not in the .gitignore of the $CWD


# Deleted files are included in the commit message as -[delted/file]
git status | grep "deleted:" | sed 's/.*deleted:....//' > $TEMPFILE
while read line ; do
	GIT_COMMIT_MESSAGE="-[$line] $GIT_COMMIT_MESSAGE"
done < $TEMPFILE


# New files are included in the commit message as +[new/file]
git status | grep "new file:" | sed 's/.*new file:...//' > $TEMPFILE
while read line ; do
	GIT_COMMIT_MESSAGE="+[$line] $GIT_COMMIT_MESSAGE"
done < $TEMPFILE


# Renamed files are included in the commit message as [old/file -> new/file]
git status | grep "renamed:" | sed 's/.*renamed:....//' > $TEMPFILE
while read line ; do
	GIT_COMMIT_MESSAGE="[$line] $GIT_COMMIT_MESSAGE"
done < $TEMPFILE


# Modified files are included in the commit message as [file]
git status | grep "modified:" | sed 's/.*modified:...//' > $TEMPFILE
while read line ; do
	GIT_COMMIT_MESSAGE="[$line] $GIT_COMMIT_MESSAGE"
done < $TEMPFILE


# The final output is in LIFO order, such that
# [edited] [moved -> renamed] +[newfile] -[deleted]

rm $TEMPFILE

if [ -n "$1" ] ; then
	GIT_COMMIT_MESSAGE="$@ $GIT_COMMIT_MESSAGE"
fi

# "optional custom commit message [edited] [moved -> renamed] +[newfile] -[deleted]"

echo "$GIT_COMMIT_MESSAGE"
