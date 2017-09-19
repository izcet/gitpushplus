#!/bin/sh

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
echo "${G}What directory should the files be stored? $B(defaults to $P$GPP_DIR$B)$N"
read RESPONSE

if [ -n "$RESPONSE" ] ; then
	GPP_DIR=$RESPONSE
fi

if [ -f $GPP_DIR ] ; then
	echo "${R}Error: File exists: $P$GPP_DIR$N"
	exit 1
fi
mkdir -p $GPP_DIR
cp ./commit_script.sh $GPP_DIR
chmod +x ${GPP_DIR}commit_script.sh


echo "${G}What .rc file do you use? $B($P.bashrc$B, $P.shrc$B, $P.zshrc$B, ...$B)$N"
read RC_FILE
while [ -z "$RC_FILE" ] ; do
	echo "${R}Filename cannot be NULL. >:("
	echo "${G}What .rc file do you use?$N"
	read RC_FILE
done
RC_FILE=$HOME/$RC_FILE


if [ -d "$RC_FILE" ] ; then
	echo "${R}Error: File cannot be a directory: $P$RC_FILE"
	echo "${B}I bet you think you're really funny.$N"
	exit 1
fi

if [ ! -f "$RC_FILE" ] ; then
	echo "${P}$RC_FILE$B does not exist. Creating..."
fi
echo "${B}Appending data to $P$RC_FILE$B.$N"


echo "\n####  Git Push Plus variables and setup  ####\n" >> $RC_FILE
echo "export GPP_DIR=$GPP_DIR" >> $RC_FILE
echo "export GPP_GREEN='\\033[0;32m'" >> $RC_FILE
echo "export GPP_BLUE='\\033[0;34m'" >> $RC_FILE
echo "export GPP_PURPLE='\\033[0;35m'" >> $RC_FILE
echo "export GPP_RED='\\033[0;31m'" >> $RC_FILE
echo "export GPP_NOCOLOR='\\033[0m'\n" >> $RC_FILE
echo "source \${GPP_DIR}$GPP_ALIAS\n" >> $RC_FILE
echo "####          End Git Push Plus          ####\n" >> $RC_FILE
echo ""


echo "${G}Setting up shortcuts!\n"
GPP_ALIAS=${GPP_DIR}$GPP_ALIAS
echo "" > $GPP_ALIAS


echo "${G}What is your default text editor?$N"
read GPP_EDITOR
while [ -z $GPP_EDITOR ] ; do
	echo "${R}You've gotta edit text at some point."
	echo "${G}What is your preferred text editor?$N"
	read GPP_EDITOR
done

if [ "$GPP_EDITOR" == "emacs" ] ; then
	echo "${B}This was written in ${P}vim$B... just saying.$N"
elif [ "$GPP_EDITOR" != "vim" ] ; then
	echo "${B}That is neither ${P}vim$B nor ${R}emacs$B.$N"
fi
echo "GPP_EDITOR=$GPP_EDITOR\n" >> $GPP_ALIAS
echo ""

echo "${G}What would you like to alias to $R$GPP_EDITOR .gitignore$G?"
echo "$B(I recommend ${P}gi$B)"
echo "(Default: exclude this option)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo "alias $RESPONSE=\"\$GPP_EDITOR .gitignore\"\n" >> $GPP_ALIAS
	echo ""
else
	echo "${B}Skipping...$N\n"
fi


COMMAND_GP="gp"
echo "${G}What would you like to alias to the ${R}GPP Git Push$G function?"
echo "$B(Default: $P$COMMAND_GP$B)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo "${B}Jeez what kind of command name is ${P}$RESPONSE$B?"
	echo "Alright I guess...$N\n"
	COMMAND_GP=$RESPONSE
fi
echo "function $COMMAND_GP () {" >> $GPP_ALIAS
cat gp_fragment.txt >> $GPP_ALIAS
echo "}\n" >> $GPP_ALIAS


echo "${G}What would you like to alias to ${R}git pull$G?"
echo "$B(Default: exclude this option)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo "alias $RESPONSE=\"git pull\"" >> $GPP_ALIAS
	echo ""
fi

COMMAND_GS="gs"
echo "${G}What would you like to alias to ${R}git status$G?"
echo "$B(Default: $P$COMMAND_GS$B)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	echo "${B}Well if you insist...$N\n"
	COMMAND_GS=$RESPONSE
fi
echo "alias $COMMAND_GS=\"git status\"" >> $GPP_ALIAS


COMMAND_GA="ga"
echo "${G}What would you like to alias to ${R}git add .$G?"
echo "$B(Default: $P$COMMAND_GA$B)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	COMMAND_GA=$RESPONSE
	echo ""
fi
echo "alias $COMMAND_GA=\"git add .\"" >> $GPP_ALIAS

COMMAND_GC="gc"
echo "${G}What would you like to alias to the ${R}GPP Git Commit$G function?"
echo "$B(Default: $P$COMMAND_GC$B)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	COMMAND_GC=$RESPONSE
	echo ""
fi
echo "\nfunction $COMMAND_GC () {" >> $GPP_ALIAS
echo "\tgit commit -m \"\$(sh ${GPP_DIR}commit_script.sh \$1)\"" >> $GPP_ALIAS
echo "}\n" >> $GPP_ALIAS


COMMAND_GALL="gall"
echo "${G}What would you like to alias to the ${R}GPP Git All$G function?"
echo "$B(Default: $P$COMMAND_GALL$B)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	COMMAND_GALL=$RESPONSE
	echo ""
fi
echo "function $COMMAND_GALL () {" >> $GPP_ALIAS
echo "\t$COMMAND_GS && $COMMAND_GA && $COMMAND_GS && $COMMAND_GC \$1 && $COMMAND_GP" >> $GPP_ALIAS
echo "\t$COMMAND_GS" >> $GPP_ALIAS
echo "}\n" >> $GPP_ALIAS


echo "${B}Sourcing $P$RC_FILE$B...$N"
source $RC_FILE
echo "${G}All done! Feel free to delete this repository now.$N"
exit
