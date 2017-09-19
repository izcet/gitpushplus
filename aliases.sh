GPP_DIR="~/.gpp_resources/"
GPP_GREEN='\033[0;32m'
GPP_PURPLE='\033[0;35m'
GPP_NOCOLOR='\033[0m'

alias gi="vim .gitignore"

function gp () {
	if [ $# != 0 ] ; then
		while [ $1 != "" ] ; do
			echo -n "${GPP_GREEN}$1: ${GPP_PURPLE}"
			git push $1 master
			shift
		done
	else
		while read line ; do
			echo -n "${GPP_GREEN}$line: ${GPP_PURPLE}"
			git push $line master
		done <(git remote)
	fi
	echo -n "$GPP_NOCOLOR"
}

# I wanted to make this portable but for now here's a short hack
alias gp="echo -n \"${GRE}origin: ${PUR}\" ; git push origin master ; echo -n \"${GRE}gh: ${BLU}\" ; git push gh master ; echo -n \"${NOC}\""

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
