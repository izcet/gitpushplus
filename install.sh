#!/bin/sh

GPP_DIR="~/.gpp_resources/"

echo "${W}What is the name of the project?"
read NAME

if [ -z "$NAME" ] ; then
	error "The name of the project cannot be NULL."
	exit
fi

if [ -d $NAME ] ; then
	error "A directory called ${P}$NAME${R} already exists."
	exit
fi

if [ -f $NAME ] ; then
	error "A file named ${P}$NAME${R} already exists."
	exit
fi

echo "${W}What kind of project is ${P}$NAME${W} going to be?"
echo "\t${C}[1]${W} Shell Script"
echo "\t${C}[2]${W} C Code"
echo "\t${C}[3]${W} Other"
read TYPE

if [ "$TYPE" -eq "1" ] ; then
	echo "${G}Initiallizing a new Shell project."
elif [ $TYPE -eq 2 ] ; then
	echo "${G}Initializing a new C project."
elif [ $TYPE -eq 3 ] ; then
	echo "${G}Initializing a new project."
else
	error "${C}$TYPE${R} is not a valid response."
	exit
fi

echo "${B}Initializing git repository."
git init $NAME >> /dev/null

cd $NAME
echo "Entering repository."

echo "${W}What is the ${C}vogsphere${W} repository url?"
read URL
while [ -z $URL ] ; do
	error "Directory or URL cannot be NULL"
	echo "${W}What is the ${C}vogsphere${W} repository url?"
	read URL
done
echo "${B}Adding remote ${C}origin${B} at ${P}$URL${B}"
git remote add origin $URL
if [ "$?" -eq 1 ] ; then
	error "Invalid repository. ${C}origin${R} will have to be manually set."
	git remote rm origin
	echo "${B}Remote ${C}origin${B} removed."
else
	git pull origin master 2> /dev/null
fi

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
echo "${B}Setting gitignore."
if [ "$TYPE" -eq "2" ] ; then
	echo "*.[oa]" >> $GIT/info/exclude
fi
echo "*.swp" >> $GIT/info/exclude

echo "${G}Creating ${P}author${G} file."
echo "$(whoami)" > author

if [ "$TYPE" -eq "1" ] ; then
	echo "${G}Creating file ${P}$NAME.sh"
	echo "#!/bin/sh\n" > $NAME.sh
fi

if [ "$TYPE" -eq "2" ] ; then
	echo "$COM" >> $VIM

	make_dir $SRC
	make_dir $INC

	make_with_vim $INC/$NAME.h
	echo "${B}Protecting against double inclusion."
	echo "#ifndef $(echo $NAME | awk '{print toupper($0)}')_H" >> $INC/$NAME.h
	echo "# define $(echo $NAME | awk '{print toupper($0)}')_H" >> $INC/$NAME.h
	echo "\n\n\n#endif" >> $INC/$NAME.h

	make_with_vim $MAK
	echo "${B}Prepopulating text in ${P}$MAK"
	add_line "NAME\t\t=\t$NAME\n" 					#line 13, 14
	add_line "CC\t\t\t=\tgcc"							#line 15
	add_line "CFLAGS\t\t=\t-Wall -Werror -Wextra"		#line 16
	add_line "XFLAGS\t\t=\t#-flags -for -X"			#line 17
	add_line "FLAGS\t\t=\t\$(CFLAGS) \$(XFLAGS)\n" #18 19
	add_line "SRC_DIR\t\t=\t$SRC"
	add_line "SRC_FILE\t=\t##!!##"
	add_line "SRCS\t\t=\t\$(addprefix \$(SRC_DIR)/, \$(SRC_FILE))\n"
	add_line "OBJ_DIR\t\t=\tobj"
	add_line "OBJ_FILE\t=\t\$(SRC_FILE:.c=.o)"
	add_line "OBJS\t\t=\t\$(addprefix \$(OBJ_DIR)/, \$(OBJ_FILE))\n"
	add_line "INC_DIR\t\t=\t-I $INC\n" # append text to specific lines
	add_line ".PHONY: all clean fclean re\n" #libft
	add_line "all: \$(NAME)\n"
	add_line "\$(NAME): \$(SRCS) | \$(OBJS)"
	add_line "\t\$(CC) \$(FLAGS) \$(OBJS) \$(INC_DIR) -o \$(NAME)\n"
	add_line "\$(OBJ_DIR)/%.o: \$(SRC_DIR)/%.c | \$(OBJ_DIR)"
	add_line "\t@\$(CC) -c \$^ \$(CFLAGS) \$(INC_DIR) -o \$@\n"
	add_line "clean:"
	add_line "\t@rm -rf \$(OBJ_DIR)\n"
	add_line "fclean: clean"
	add_line "\t@rm -f \$(NAME)\n"
	add_line "re: fclean all\n"
	add_line "\$(OBJ_DIR):"
	add_line "\t@mkdir -p \$(OBJ_DIR)"

	echo "${W}Would you like to include $P$LIB$W from $P$LDIR$W ?"
	echo "\t${C}[1]$W yes"
	echo "\t${C}[2]$W no"
	read TYPE
	if [ "$TYPE" -eq "1" ] ; then
		add_lib
	elif [ "$TYPE" -ne "2" ] ; then
		error "${C}$TYPE${R} is not a valid response."
	fi

	echo "${W}Would you like to include another library?"
	echo "\t${C}[1]$W yes"
	echo "\t${C}[2]$W no"
	read TYPE
	while [ "$TYPE" -eq "1" ] ; do
		echo "${W}Enter library directory name:"
		read LIB
		echo "Enter path to library: (full path to library)"
		read LDIR
		add_lib
		echo "${W}Would you like to include another library?"
		echo "\t${C}[1]$W yes"
		echo "\t${C}[2]$W no"
		read TYPE
	done
	if [ "$TYPE" -ne "2" ] ; then
		error "${C}$TYPE${R} is not a valid response."
	fi
	rm $VIM
fi

echo "${B}Adding files to git and making first commit.${W}"
git add .
git status
git commit -m "Initial commit"
echo "\n\t${G}Done.${N}\n"
