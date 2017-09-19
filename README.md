# Git Push Plus (GPP)
A tool for improving git commit tracking and overall command line simplification.

#### Why
I don't always have the time or remember to write out a verbose commit message of all the changes I made to any number of files, especially when I make multiple small changes. So It's more useful to me to be able to quickly see which files were added, edited, and removed when, so I can backtrack to a specific commit more quickly. 
<br><br>
I originally just made this for me but I've had a couple requests by others who found it cool so I created this separate repo to allow others to install.

#### Features:
 - Fully add/commit/push a file with only one command!
 - Always [verbose](#verbose-commits) commit messages!
 - Multiple remote push automation!
 - Painless, one-time setup with customization!
 - Bash Wizardry!

#### Setup:
Just download and run `install.sh`, and the setup process is pretty painless. It asks you some questions about your environment and preferences, and then copies/generates the necessary files.
<br><br>
![install.sh](https://raw.githubusercontent.com/izcet/gitpushplus/master/pic/install.png)
<br>
It appends the necessary sourcing to the specified file (`.bashrc` in this example):
```
####  Git Push Plus variables and setup  ####

export GPP_DIR=/tmp/bar/
export GPP_GREEN='^[[0;32m'
export GPP_BLUE='^[[0;34m'
export GPP_PURPLE='^[[0;35m'
export GPP_RED='^[[0;31m'
export GPP_NOCOLOR='^[[0m'

source ${GPP_DIR}aliases.sh

####          End Git Push Plus          ####
```
And generates/copies the files being sourced (`aliases.sh`):
```
GPP_EDITOR=vim

function gp () {
	if [ $# != 0 ] ; then
		while [ "$1" != "" ] ; do
			echo -n "${GPP_GREEN}$1: ${GPP_PURPLE}"
			git push $1 master
			shift
		done
	else
		GPP_TEMP_FILE="$(whoami)_temp_file_$(date).txt"
		git remote > $GPP_TEMP_FILE
		while read line ; do
			echo -n "${GPP_GREEN}$line: ${GPP_PURPLE}"
			git push $line master
		done < $GPP_TEMP_FILE
		rm -rf $GPP_TEMP_FILE
	fi
	echo -n "$GPP_NOCOLOR"
}

alias gu="git pull"
alias gstat="git status"
alias ga="git add ."

function gc () {
	git commit -m "$(sh /tmp/bar/commit_script.sh $1)"
}

function gall () {
	gstat && ga && gstat && gc $1 && gp
	gstat
}
```
<br><br>
<br><br>

### Verbose commits
 - Takes advantage of `grep` and `git status` to parse the changes into a string.
 - Takes optional user input to provide custom commit messages prior to the list of changed files.
 - [source](https://github.com/izcet/gitpushplus/blob/master/commit_script.sh)
<br>

```
$> gc
[master 3d980cd] [README.md] +[pic/commit.png]
 2 files changed, 3 insertions(+)
 create mode 100644 pic/commit.png
$>
```

<br><br>
```
$> gc "Updated Readme and revised image preview"
[master 6d2ddf3] Update Readme and revised image preview [pic/install.png] [install.sh] [README.md]
 3 files changed, 20 insertions(+), 4 deletions(-)
 rewrite pic/install.png (95%)
$>
```
<br><br>
<br><br>

### Git Push Plus All
This command chains together all of the other shorthands to provide a quick way to fully commit and push to all remotes. You can combine the optional verbose commit message with this command and it's passed through.
<br><br>

![Git Push Plus All](https://raw.githubusercontent.com/izcet/gitpushplus/master/pic/gall.png)

<br><br>
