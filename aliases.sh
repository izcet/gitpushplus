GPP_DIR=~/.gpp_resources/
GPP_GREEN='\033[0;32m'
GPP_PURPLE='\033[0;35m'
GPP_NOCOLOR='\033[0m'

alias gi="vim .gitignore"

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

alias gq="git pull"
alias gs="git status"
alias ga="git add ."

# References my mini git commit automation script
function gc () {
	git commit -m "$(sh ${GPP_DIR}git_commit_script.sh $1)"
}

# Shortcuts on shortcuts
function gall () {
	gs
	ga
	gs
	gc $1
	gp
	gs
}
