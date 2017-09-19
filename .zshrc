#### Color codes ##############################################################

RED='\033[0;31m'
ORA='\033[0;33m'
#YEL='\033[1;33m'
GRE='\033[0;32m'
CYA='\033[0;36m'
BLU='\033[0;34m'
PUR='\033[0;35m'
NOC='\033[0m'

#### Exports ##################################################################

# change to be portable
export PATH="$PATH:/usr/local/mysql/bin"
export PATH="$PATH:$HOME/.texlive/bin/x86_64-darwin/"
export PATH="$PATH:$HOME/.gem/ruby/2.0.0/bin"
export PATH="$HOME/goinfre/brew/bin:$PATH"
export PATH="$PATH:$HOME/.bin"
export FT42_UID=$(cat ~/.ft_42/uid)
export FT42_SECRET=$(cat ~/.ft_42/secret)
export RAPIDIO_KEY=$(cat ~/.apikeys/rapidio)
#export SENDGRID=$(cat backups/projects/hercules/girdle_of_hippolyta/api.key)
export MAIL="irhett@student.42.us.org"
#export CLICOLOR=0
export CLICOLOR=1
export MANPATH="$MANPATH:$HOME/backups/projects/fdf/mlx/man"
export MANPATH="$MANPATH:$HOME/.texlive/texmf-dist/doc/man"
export PYTHONPATH="$PYTHONPATH:$HOME/.texlive/pygmentize"
export PATH="$PATH:$PYTHONPATH"
export GITBACKUPDIR=~/backups/scripts-gitbackup/


### #Login Scripts ############################################################

# - clean up the iTerm 2 crashes
if [ "$(ls -A ~/Library/Logs/DiagnosticReports/)" ] ; then
	echo "${BLU}Cleaning iTerm Crashes... \c"
	(rm ~/Library/Logs/DiagnosticReports/*.crash 2> /dev/null & )
	echo "${GRE}Done${NOC}"
fi

# - git backup of .zshrc and .vimrc
CURRENT_WORKING_DIRECTORY=$PWD
if [ "$CURRENT_WORKING_DIRECTORY" = "/nfs/2016/i/irhett" ] ; then
	echo "${BLU}Backing up dotfiles. Copying... \c"
	cp -r ~/.zshrc ~/.vimrc ~/.brew $GITBACKUPDIR &> /dev/null
	cd $GITBACKUPDIR
	echo "${GRE}Done${NOC}"
	git add .
	if [ "$(git status | wc -l | tr -d ' ')" -gt "3" ] ; then
		echo "${ORA}\c"
		git commit -m "$(sh .git_commit_script.sh)$(date)"
		echo "${BLU}Pushing to github... \c"
		( git push gh master &> /dev/null )
		echo "${GRE}Done${NOC}"
	fi

	cd $CURRENT_WORKING_DIRECTORY

	# - Install brew
	if [ ! -e "$HOME/goinfre" ] ; then
		echo "${BLU}Making goinfre... \c"
		mkdir /goinfre/$(whoami)
		echo "${GRE}Done${NOC}"
	fi

	if [ ! -d "$HOME/goinfre/brew/bin" ] ; then
		echo "${BLU}Cloning Brew... ${NOC}\c"
		(git clone https://github.com/Homebrew/homebrew.git ~/goinfre/brew ; brew update &)
		echo "${GRE}Done${NOC}"
	fi

	BREWSCRIPTS=~/.brew/install.sh
	if [ -f $BREWSCRIPTS ] ; then
		if [ ! -f "$HOME/goinfre/brew/bin/brew" ] ; then
			echo -n "${BLU}Waiting for brew to install.${NOC}"
			while [ ! -f "$HOME/goinfre/brew/bin/brew" ] ; do
				sleep 1
				echo -n "${BLU}.${NOC}"
			done
			echo "${GRE}Done.${NOC}"
		fi
		echo -n "${BLU}Brew installing packages... ${NOC}"
		(sh $BREWSCRIPTS & )
		echo "${GRE}Done.${NOC}"
	else
		echo "${RED}Brew script file ${PUR}$BREWSCRIPTS${RED} not found.${NOC}"
	fi
fi

# - Supposed to set Vim as manpage viewer, Don't think it works
#if type "vim" > /dev/null; then
#	PAGER='col -bx | vim -c ":set ft=man nonu nolist" -R -'
#fi

#### Functions ################################################################

function find42 () {
	ldapsearch -QLLL uid=$1 | sed '/jpegPhoto/q' | grep -v jpegPhoto | grep -v objectClass
}

function starfleet () {
	mkdir $1
	cp -rf resources/$1/* $1
}

#### Aliases ##################################################################

# Aliases local to the Zones
alias norm="norminette -R CheckForbiddenSourceHeader"
alias ft="echo -n \"\e(0\" ; ft_42 irhett"
alias vb="vim ~/.brew/"
alias :q="exit"
alias :wq="exit"

# More portable scripts I want everywhere
source ${GITBACKUPDIR}aliases.sh

# LaTeX
alias repdf="make re ; /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome *.pdf"

alias comehugme="ssh izcet@comehug.me -p 57183"
alias piratedspace="ssh captain@pirated.space -p 57185"

alias dubiousvault="ssh dubious@pirated.space -p 57183"
alias dubiouslocal="ssh dubious@10.10.190.11 -p 57183"
alias isaacvault="ssh irhett@pirated.space -p 57183"
alias isaaclocal="ssh irhett@10.10.190.11 -p 57183"

alias musings="ssh keras@107.170.212.195 -p 42000"
####  Git Push Plus variables and setup  ####

export GPP_DIR=/nfs/2016/i/irhett/.gpp_resources/
export GPP_GREEN='[0;32m'
export GPP_PURPLE='[0;35m'
export GPP_RED='[0;31m'
export GPP_NOCOLOR='[0m'

source 81615{GPP_DIR}aliases.sh

####          End Git Push Plus          ####
