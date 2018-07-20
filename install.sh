#!/bin/bash

GPP_DIR=~/.gpp_resources/
GPP_ALIAS=aliases.sh

GPP_GREEN='\033[0;32m'
GPP_BLUE='\033[0;34m'
GPP_PURPLE='\033[0;35m'
GPP_RED='\033[0;31m'
GPP_NOCOLOR='\033[0m'

G=$GPP_GREEN
B=$GPP_BLUE
P=$GPP_PURPLE
R=$GPP_RED
N=$GPP_NOCOLOR


# Initial setup of files
echo -e "${G}What directory should the files be stored? $B(defaults to $P$GPP_DIR$B)$N"
read RESPONSE

if [ -n "$RESPONSE" ] ; then
	GPP_DIR="$RESPONSE"
	echo -e ""
fi

if [ -f $GPP_DIR ] ; then
	echo -e "${R}Error: File exists: $P$GPP_DIR$N"
	exit 1
fi
mkdir -p "$GPP_DIR"
cp ./commit_script.sh "$GPP_DIR"
chmod +x "${GPP_DIR}commit_script.sh"


echo -e "${G}What .rc file do you use? $B($P.bashrc$B, $P.shrc$B, $P.zshrc$B, ...$B)$N"
read RC_FILE
while [ -z "$RC_FILE" ] ; do
	echo -e "${R}Filename cannot be NULL. >:("
	echo -e "${G}What .rc file do you use?$N"
	read RC_FILE
done
RC_FILE="$HOME/$RC_FILE"


if [ -d "$RC_FILE" ] ; then
	echo -e "${R}Error: File cannot be a directory: $P$RC_FILE"
	echo -e "${B}I bet you think you're really funny.$N"
	exit 1
fi

if [ ! -f "$RC_FILE" ] ; then
	echo -e "${P}$RC_FILE$B does not exist. Creating..."
fi
echo -e "${B}Appending data to $P$RC_FILE$B.$N"


echo -e "# Git Push Plus" >> "$RC_FILE"
echo -e "# Author: Isaac Rhett" >> "$RC_FILE"
echo -e "# Repo: https://github.com/izcet/gitpushplus\n" >> "$RC_FILE"
echo -e "export GPP_DIR=$GPP_DIR" >> "$RC_FILE"
echo -e "export GPP_GREEN='\\033[0;32m'" >> "$RC_FILE"
echo -e "export GPP_BLUE='\\033[0;34m'" >> "$RC_FILE"
echo -e "export GPP_PURPLE='\\033[0;35m'" >> "$RC_FILE"
echo -e "export GPP_RED='\\033[0;31m'" >> "$RC_FILE"
echo -e "export GPP_NOCOLOR='\\033[0m'\n" >> "$RC_FILE"
echo -e "source \${GPP_DIR}$GPP_ALIAS\n" >> "$RC_FILE"
echo -e "# End Git Push Plus\n" >> "$RC_FILE"
echo -e ""


GPP_ALIAS="${GPP_DIR}$GPP_ALIAS"
echo -e "" > "$GPP_ALIAS"


echo -e "${G}What is your default text editor?$N"
read GPP_EDITOR
while [ -z "$GPP_EDITOR" ] ; do
	echo -e "${R}You've gotta edit text at some point."
	echo -e "${G}What is your preferred text editor?$N"
	read GPP_EDITOR
done

if [ "$GPP_EDITOR" == "emacs" ] ; then
	echo -e "${B}This was written in ${P}vim$B... just saying.$N"
elif [ "$GPP_EDITOR" != "vim" ] ; then
	echo -e "${B}That is neither ${P}vim$B nor ${R}emacs$B.$N"
fi
echo -e "GPP_EDITOR=$GPP_EDITOR\n" >> "$GPP_ALIAS"
echo -e ""

echo -e "${G}What would you like to alias to $R$GPP_EDITOR .gitignore$G?"
echo -e "$B(I recommend ${P}gi$B)"
echo -e "(Default: exclude this option)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo -e "alias $RESPONSE=\"\$GPP_EDITOR .gitignore\"\n" >> "$GPP_ALIAS"
	echo -e ""
fi

COMMAND_GP="gp"
echo -e "${G}What would you like to alias to the ${R}GPP Git Push$G function?"
echo -e "$B(Default: $P$COMMAND_GP$B)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo -e "${B}Jeez what kind of command name is ${P}$RESPONSE$B?"
	echo -e "Alright I guess...$N\n"
	COMMAND_GP="$RESPONSE"
fi
echo -e "function $COMMAND_GP () {" >> "$GPP_ALIAS"
cat gp_fragment.txt >> "$GPP_ALIAS"
echo -e "}\n" >> "$GPP_ALIAS"


echo -e "${G}What would you like to alias to ${R}git pull$G?"
echo -e "$B(I recommend ${P}gu$B)"
echo -e "$B(Default: exclude this option)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo -e "alias $RESPONSE=\"git pull\"" >> "$GPP_ALIAS"
    echo -e ""
fi

echo -e "${G}What would you like to alias to ${R}git diff$G?"
echo -e "$B(I recommend ${P}gd$B)"
echo -e "$B(Default: exclude this option)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo -e "alias $RESPONSE=\"git diff\"" >> "$GPP_ALIAS"
	echo -e ""
fi

COMMAND_GS="gs"
echo -e "${G}What would you like to alias to ${R}git status$G?"
echo -e "$B(Default: $P$COMMAND_GS$B)$N"
echo -e "${R}Be warned that this will collide with GhostScript, if present on your machine.$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo -e "${B}Well if you insist...$N\n"
	COMMAND_GS="$RESPONSE"
fi
echo -e "alias $COMMAND_GS=\"git status\"" >> "$GPP_ALIAS"


COMMAND_GA="ga"
echo -e "${G}What would you like to alias to ${R}git add .$G?"
echo -e "$B(Default: $P$COMMAND_GA$B)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	COMMAND_GA="$RESPONSE"
	echo -e ""
fi
echo -e "alias $COMMAND_GA=\"git add .\"" >> "$GPP_ALIAS"

COMMAND_GC="gc"
echo -e "${G}What would you like to alias to the ${R}GPP Git Commit$G function?"
echo -e "$B(Default: $P$COMMAND_GC$B)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	COMMAND_GC="$RESPONSE"
	echo -e ""
fi
echo -e "\nfunction $COMMAND_GC () {" >> "$GPP_ALIAS"
echo -e "\tgit commit -m \"\$(${GPP_DIR}commit_script.sh \$@)\"" >> "$GPP_ALIAS"
echo -e "}\n" >> "$GPP_ALIAS"


COMMAND_GALL="gall"
echo -e "${G}What would you like to alias to the ${R}GPP Git All$G function?"
echo -e "$B(Default: $P$COMMAND_GALL$B)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	COMMAND_GALL="$RESPONSE"
	echo -e ""
fi
echo -e "function $COMMAND_GALL () {" >> "$GPP_ALIAS"
echo -e "\t$COMMAND_GS && $COMMAND_GA && $COMMAND_GS && $COMMAND_GC \$@ && $COMMAND_GP" >> "$GPP_ALIAS"
echo -e "\t$COMMAND_GS" >> "$GPP_ALIAS"
echo -e "}\n" >> "$GPP_ALIAS"


echo -e "${B}Sourcing $P$RC_FILE$B...$N"
source "$RC_FILE"
echo -e "${G}All done! Feel free to delete this repository now.$N"
exit
