# Git Push Plus (GPP)
A tool for improving git commit tracking and overall command line simplification.
<br><br>
#### Why
I don't always have the time or remember to write out a verbose commit message of all the changes I made to any number of files, especially when I make multiple small changes. So It's more useful to me to be able to quickly see which files were added, edited, and removed when, so I can backtrack to a specific commit more quickly.

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
<br>
![aliases](https://raw.githubusercontent.com/izcet/gitpushplus/cf0dbdeb692aef09fd363639e7dd685b9d90d578/pic/alias.png)
<br><br>

### Verbose commits
 - Takes advantage of `grep` and `git status` to parse the changes into a string.
 - Takes optional user input to provide custom commit messages prior to the list of changed files.
 - [source](https://github.com/izcet/gitpushplus/blob/master/commit_script.sh)
<br>
![commitexample](https://raw.githubusercontent.com/izcet/gitpushplus/master/pic/commit2.png)
<br>
![Verbose commit example](https://raw.githubusercontent.com/izcet/gitpushplus/master/pic/commit.png)

### Git Push Plus All
This command chains together all of the other shorthands to provide a quick way to fully commit and push to all remotes.
<br>
![Git Push Plus All](https://raw.githubusercontent.com/izcet/gitpushplus/master/pic/gall.png)
