# Git Push Plus (GPP)
A tool for improving git commit tracking and overall command line simplification.

#### Features:
 - Fully commit a file with only [one command](#Git-Push-Plus-All) and verbose output!
 - Always [verbose](#Verbose-commits) commit messages!
 - Multiple remote push automation!
 - Painless, one-time setup with customization!
 - Bash Wizardry!

#### Setup:
Just download and run `install.sh`, and the setup process is pretty painless. It asks you some questions about your environment and preferences, and then copies/generates the necessary files.
<br>
![install.sh](https://raw.githubusercontent.com/izcet/gitpushplus/master/pic/install.png)
<br>
It appends the necessary sourcing to the specified file:
<br>
![.dotfile example](https://raw.githubusercontent.com/izcet/gitpushplus/master/pic/bashrc.png)
<br>
And generates/copies the files being sourced:
![aliases](https://raw.githubusercontent.com/izcet/gitpushplus/master/pic/bashrc.png)

#### Verbose commits
 - Takes advantage of `grep` and `git status` to parse the changes into a string.
 - Takes optional user input to provide custom commit messages prior to the list of changed files.

#### Git Push Plus All
This command chains together all of the other shorthands to:
 - Commit all changed files with the verbose commit option (Including a custom commit message if desired)
 - Push to all remotes on file
<br>
![Git Push Plus All](https://raw.githubusercontent.com/izcet/gitpushplus/master/pic/gall.png)
