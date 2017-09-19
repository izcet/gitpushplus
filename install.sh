#!/bin/sh

GPP_DIR=~/.gpp_resources/
GPP_ALIAS=aliases.sh
GPP_GREEN='\033[0;32m'
GPP_PURPLE='\033[0;35m'
GPP_RED='\033[0;31m'
GPP_NOCOLOR='\033[0m'

G=$GPP_GREEN
P=$GPP_PURPLE
R=$GPP_RED
N=$GPP_NOCOLOR


# Initial setup of files
echo "${G}What directory should the files be stored? (defaults to $P$GPP_DIR$G)$N"
read RESPONSE

if [ -n "$RESPONSE" ] ; then
	GPP_DIR=$RESPONSE
fi

if [ -f $GPP_DIR ] ; then
	echo "${R}Error: File exists: $P$GPP_DIR$N"
	exit 1
fi
cp ./commit_script.sh $GPP_DIR
chmod +x ${GPP_DIR}commit_script.sh


echo "${G}What .rc file do you use? ($P.bashrc$G, $P.shrc$G, $P.zshrc$G)$N"
read RC_FILE
while [ -z $RC_FILE ] ; do
	echo "${R}Filename cannot be NULL. >:("
	echo "${G}What .rc file do you use?$N"
	read RC_FILE
done

if [ -d $RC_FILE ] ; then
	echo "${R}Error: File cannot be a directory: $P$RC_FILE"
	echo "${G}I bet you think you're really funny.$N"
	exit 1
fi

if [ ! -f $RC_FILE ] ; then
	echo "${P}$RC_FILE$G does not exist. Creating..."
	touch $RC_FILE
fi


echo "${G}Appending data to $P$RC_FILE$G.$N"

echo "####  Git Push Plus variables and setup  ####\n" >> $RC_FILE
echo "export GPP_DIR=$GPP_DIR" >> $RC_FILE
echo "export GPP_GREEN='\\033[0;32m'" >> $RC_FILE
echo "export GPP_PURPLE='\\033[0;35m'" >> $RC_FILE
echo "export GPP_RED='\\033[0;31m'" >> $RC_FILE
echo "export GPP_NOCOLOR='\\033[0m'\n" >> $RC_FILE
echo "source $${GPP_DIR}$GPP_ALIAS\n" >> $RC_FILE
echo "####          End Git Push Plus          ####" >> $RC_FILE
echo ""


echo "${G}Setting up shortcuts!"
GPP_ALIAS=${GPP_DIR}$GPP_ALIAS
echo "" > $GPP_ALIAS
echo ""


echo "${G}What is your default text editor?$N"
read GPP_EDITOR
while [ -z $GPP_EDITOR ] ; do
	echo "${R}You've gotta edit text at some point."
	echo "${G}What is your preferred text editor?$N"
	read GPP_EDITOR
done
if [ "$GPP_EDITOR" -eq "emacs" ] ; then
	echo "${G}This was written in ${P}vim$G... just saying.$N"
else if [ "$GPP_EDITOR" -ne "vim" ] ; then
	echo "${G}That is neither ${P}vim$G nor ${R}emacs$G."
fi
echo "GPP_EDITOR=$GPP_EDITOR\n" >> $GPP_ALIAS
echo ""


echo "${G}What would you like to alias to $R$GPP_EDITOR .gitignore$G?"
echo "(I recommend ${P}gi$G)"
echo "(Default: exclude this option)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo "alias $RESPONSE=\"$$GPP_EDITOR .gitignore\"\n"
else
	echo "${G}Skipping...$N"
fi
echo ""


echo "What would you like to alias to the ${R}GPP Git Push$G function?"
echo "(Default: ${P}gp$G)$N"
read RESPONSE
COMMAND_GP="gp"
if [ -n "$RESPONSE" ] ; then
	echo "${G}Jeez what kind of command name is ${P}$RESPONSE$G?"
	echo "Alright I guess...$N"
	COMMAND_GP=$RESPONSE
fi
echo "function $COMMAND_GP () {" >> $GPP_ALIAS
cat gp_fragment.txt >> $GPP_ALIAS
echo "}\n" >> $GPP_ALIAS
echo ""


echo "What would you like to alias to ${R}git pull$G?"
echo "(Default: exclude this option)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo "alias $RESPONSE=\"git pull\"" >> $GPP_ALIAS
else
	echo "${G}Skipping...$N"
fi
echo ""


echo "${G}What would you like to alias to ${R}git status$G?"
echo "(Default: ${P}gs$G)$N"
read RESPONSE
COMMAND_GS="gs"
if [ -n $RESPONSE ] ; then
	echo "${G}Well if you insist...$N"
	COMMAND_GS=$RESPONSE
	echo ""
fi
echo "alias $COMMAND_GS=\"git status\"" >> $GPP_ALIAS


echo "${G}What would you like to alias to ${R}git add .$G?"
echo "(Default: ${P}ga$G)$N"
read RESPONSE
COMMAND_GA="ga"

