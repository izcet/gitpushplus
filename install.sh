#!/bin/sh

GPP_DIR=~/.gpp_resources/
GPP_GREEN='\033[0;32m'
GPP_PURPLE='\033[0;35m'
GPP_RED='\033[0;31m'
GPP_NOCOLOR='\033[0m'


G=$GPP_GREEN
P=$GPP_PURPLE
R=$GPP_RED
N=$GPP_NOCOLOR


echo "${G}What directory should the files be stored? (defaults to $P$GPP_DIR$G)$N"
read RESPONSE
if [ -n "$RESPONSE" ] ; then
	GPP_DIR=$RESPONSE
fi

echo "${G}What .rc file do you use? ($P.bashrc$G, $P.shrc$G, $P.zshrc$G)$N"
read RC_FILE
while [ -z $RC_FILE ] ; do
	echo "${R}Filename cannot be NULL. >:("
	echo "${G}What .rc file do you use?$N"
	read RC_FILE
done

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
echo "source $${GPP_DIR}aliases.sh\n" >> $RC_FILE
echo "####          End Git Push Plus          ####" >> $RC_FILE



echo "${W}(OPTIONAL) What is the ${C}github${W} repository url?"
echo "Press enter to skip..."
read URL
if [ ! -z $URL ] ; then
	echo "${B}Adding remote ${C}gh${B} at ${P}$URL${B}"
	git remote add gh $URL
	if [ "$?" -eq 1 ] ; then
		error "Invalid repository. ${C}gh${R} will have to be manually set."
		git remote rm gh
		echo "${B}Remote ${C}gh${B} removed."
	else
		git pull gh master 2> /dev/null	
	fi
else
	echo "\033[1A${B}Skipping..."
fi

if [ ! -z $GIT_DIR ] ; then
	GIT=$GIT_DIR
fi

