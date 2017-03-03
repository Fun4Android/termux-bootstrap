#!/data/data/com.termux/files/usr/bin/env bash

# /data/data/com.termux/files/etc/bash.bashrc
write_bash_bashrc () {
	(
cat << '_EOF_'
# /data/data/com.termux/files/usr/etc/bash.bashrc

command_not_found_handle() {
	/data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
}

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# source termux env variables for bash
HOME=/data/data/com.termux/files/home
PREFIX=/data/data/com.termux/files/usr
LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib

# source the bin path for home directory
if [[ -d ${HOME}/bin ]]; then
	PATH=${HOME}/bin:${PATH}
fi

# set the python path
if [[ -d ${HOME}/python ]]; then
	PYTHONPATH=${HOME}/python:${PYTHONPATH}
fi

# enable colorful terminal -- see note
# note: 
# different devices may have different base configurations.
# use the 'find' command to locate it (you may need su installed
# depending on your device). for example, as a normal user,
# 	$ find / ! -readable -prune -o -print -type f | grep bash | less

use_color=true

if [[ ${EUID} == 0 ]] ; then
	PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
	PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \W \$\[\033[00m\] '
fi

# export environmental paths
export HOME PREFIX PATH LD_LIBRARY_PATH PYTHONPATH PS1

# source aliases for bash
if [[ -f ${HOME}/.bash.aliases ]]; then
	. ${HOME}/.bash.aliases
fi

unset use_color
_EOF_
	) > "${SCRIPTS}/bash.bashrc"
}

# /data/data/com.termux/files/home/.bash.aliases
write_bash_aliases () {
	(
cat << '_EOF_'
# /data/data/com.termux/files/home/.bash.aliases

# set aliases for bash

# enable color support of ls and also add handy aliases
if [ -x "${PREFIX}/bin/dircolors" ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=always'
    alias dir='dir --color=always'
    alias vdir='vdir --color=always'
    
    # set aliases for grep
    alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
fi

# set aliases for ls
alias l='ls -HF'
alias ll='ls -lhFH'
alias la='ls -lhAFH'
alias lh='ls -ldhFH .[!.]?*'

# make ln, rm, mv, and cp verbose
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias ln='ln -v'
_EOF_
	) > "${SCRIPTS}/bash.aliases"
}

# /data/data/com.termux/files/home/bin/sudo
write_sudo () {
	# requires a rooted device using su
	(
cat << '_EOF_'
#!/data/data/com.termux/files/usr/bin/env bash

# sudo -- excute script to become root on android for termux

echo 'Attempting to become root...'

su -c "export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib; 
if [[ 'root' -eq $(whoami) ]]; then
	echo 'You are root.';
else
	echo 'You are not root.';
	exit;
fi;
bash;"

if [[ 0 == "$?" ]]; then
	echo "Good exit status."
else
	echo "Bad exit status: $?"
fi
_EOF_
	) > "${SCRIPTS}/sudo"
}

# /data/data/com.termux/files/home/bin/patchme
write_patchme () {
	(
cat << '_EOF_'
#!/data/data/com.termux/files/usr/bin/env bash

# srctest -- compare the dates between two source files

# outline:
#	[command] [options] [arg] [arg]
#	srctest source destination
#
#	the idea is basically to perform a crude comparison between the
#	ages of the source file and the destination file, if the
#	destination file is newer than the source, then the file is NOT
#	over-written. If the source file is newer than the destination
#	file, it IS over-written.
#

declare PROGNAME VERBOSE SOURCE TARGET PATCH

PROGNAME="$(basename $0)"
SOURCE=
TARGET=
PATCH=
OPTION=

echo_usage_notice () {
	echo "Usage: $PROGNAME [ -h | -v | -o ] [ source file ] [ target file ]"
}

echo_usage_summary () {
	cat <<- _EOF_
		Usage: $PROGNAME [ option ] [ source file ] [ target file ]

		Summary
		-------
		This script attempts to perform a crude comparison between the
		ages of the source file and the destination file.

		If the destination file is newer than the source, then the file
		is NOT over written.

		If the source file is newer than the destination file, it IS
		over written.

		Options
		-------
		-h --help 		Displays this help text

		-b --back-up 		Creates a back-up of the original file

		-n --back-up-num 	Creates a numbered back-up of the original file

		-d --dry-run		Dry-run to find errors

		-r --reverse		Reverse a patch

		Arguments
		---------
		[source]		The outdated source file (the file to be updated)

		[target]		The updated source file (the file to be used for updating)
	_EOF_
}

is_file () {
	FILE="$1"

	if [[ ! -f "$FILE" ]]; then
		echo "not ok"
	fi
}

file_check () {
	FILE="$1"
	if [[ "not ok" == "$(is_file $FILE)" ]]; then
		echo "Exit: Argument '$FILE' is NOT a file."
		exit
	fi
}

if (( 0 == $# )); then
	echo_usage_notice
	exit
fi

case "$1" in
	-h|--help)
		echo_usage_summary
		exit
		;;
	-b|--back-up)
		OPTION="backup"
		shift
		;;
	-n|--back-up-num)
		OPTION="numbered"
		shift
		;;
	-d|--dry-run)
		OPTION="dryrun"
		shift
		;;
	-r|--reverse)
		OPTION="reverse"
		shift
		;;
	-*)
		echo_usage_notice
		exit
		;;
esac

SOURCE="$1"
TARGET="$2"

if [[ "$SOURCE" == "$TARGET" ]]; then
	echo "Exit: [source] can NOT be equal to [target]"
	exit
fi

PATCH="${SOURCE%%.*}.patch"

if [[ -f "$SOURCE" && -f "$TARGET" ]]; then
	diff -Naur "$SOURCE" "$TARGET" > "$PATCH"
fi

case "$OPTION" in
	backup)
		file_check "$SOURCE"
		file_check "$TARGET"
		patch -b < "$PATCH"
		;;
	numbered)
		file_check "$SOURCE"
		file_check "$TARGET"
		patch -b -V < "$PATCH"
		;;	
	dryrun)
		file_check "$SOURCE"
		file_check "$TARGET"
		patch --dry-run < "$PATCH"
		;;
	reverse)
		file_check "$SOURCE"
		patch -R < "$PATCH"
		;;
	*)
		file_check "$SOURCE"
		file_check "$TARGET"
		patch < "$PATCH"
		;;
esac
_EOF_
	) > "${SCRIPTS}/patchme"
}

# /data/data/com.termux/files/home/bin/pylist
write_pylist () {
	# requires a rooted device using su
	(
cat << '_EOF_'
#!/data/data/com.termux/files/usr/bin/env bash
#
# pylist -- attempts to filters python src files/dirs in a clean way 
#
# outline:
# 	[[command] [options] [[arg]...]]
#	pylist files -> lists only src files
#	pylist dirs -> lists only directorys
#
#	I got tired of writing small snippets of scripts to view
#	python source files without the bytecode files while filtering
#	out valid packages (directories) found within the src tree
#
#	This way I can cleanly see what src files are available
#	and the packages that accompany those modules
#

# log the program name
PROGNAME="$(basename $0)"

_echo_usage_notice () {
	echo "Usage: $PROGNAME [ -h | --help | -p | -m | -b ] [ filepath ]"
}

_echo_usage_summary () {
	cat <<- _EOF_
		Usage: $PROGNAME [ -h | -p | -m | -b ] [filepath]

		Summary
		-------
		$PROGNAME 		Filter 'ls' output for python source files 

		Options
		-------
		-h --help 		Display this help text
		-p --packages 		List only the packages within a source tree
		-m --modules 		List only the modules within a source tree
		-b --bytecode 		List only the bytecode within a source tree

		Arguments
		---------
		[filepath] 		The path containing the modules or packages

		Examples
		--------
		Ex 1: lists only the modules found within the kivy package
		#	$PROGNAME --modules /usr/lib/python-2.7/dist-packages/kivy

		Ex 2: lists only the packages found within the kivy package
		#	$PROGNAME -p /usr/lib/python-2.7/dist-packages/kivy

		Ex 3: lists only the bytecode files found with the current working directory
		#	$PROGNAME -b .
	_EOF_
}

# checks to see if param is empty
_check_if_empty () {
	filepath="$1"

	# make sure the filepath isn't empty
	if [[ -z "$filepath" ]]; then
		echo "No filepath was given."
		exit
	fi
}

# check for positional parameters as arguments
if (( 0 == $# )); then
	_echo_usage_notice
	exit
else
	read OPTION FILEPATH <<< "$1 $2"
fi

# check if positional parameters are options
case "$OPTION" in
	-h|--help)
		_echo_usage_summary

		exit
		;;

	-p|--packages)
		_check_if_empty "$FILEPATH"

		for item in ${FILEPATH}/*; do
			if [[ -d "$item" ]]; then
				ls -lhHd "${item}/"
			fi
		done

		exit
		;;

	-m|--modules)
		_check_if_empty "$FILEPATH"

		for item in ${FILEPATH}/*; do
			if [[ -f "$item" && "$item" =~ \.py$ ]]; then
				ls -lhH "$item"
			fi
		done

		exit
		;;
	-b|--bytecode)
		_check_if_empty "$FILEPATH"

		for item in ${FILEPATH}/*; do
			if [[ -f "$item" && "$item" =~ \.pyc$ ]]; then
				ls -lhH "$item"
			fi
		done

		exit
		;;
	*)
		_echo_usage_notice

		exit
		;;
esac
_EOF_
	) > "${SCRIPTS}/pylist"
}

# /data/data/com.termux/files/home/bin/update
write_update () {
	# requires a rooted device using su
	(
cat << '_EOF_'
#!/data/data/com.termux/files/usr/bin/env bash

# update -- updates termux using apt and py modules using pip

keywords=("update" "upgrade" "autoremove")

pip2_updates () {
	if [[ -n "$(which pip2)" ]]; then	
		pip2 install --upgrade pip
		
		pip_pkg=$(pip2 list -o --format=legacy | cut -d ' ' -f 1)
		
		if [[ -n "$pip_pkg" ]]; then
			pip2 install --upgrade "$pip_pkg"
		fi
	fi
}

pip3_updates () {
	if [[ -n "$(which pip3)" ]]; then	
		pip3 install --upgrade pip
		
		pip_pkg=$(pip3 list -o --format=legacy | cut -d ' ' -f 1)
		
		if [[ -n "$pip_pkg" ]]; then
			pip3 install --upgrade "$pip_pkg"
		fi
	fi	
}

updates () {
	for word in "${keywords[@]}"; do
		if [[ "upgrade" == "$word" || "autoremove" == "$word" ]]; then
			apt "$word" -y
		else
			apt "$word"
		fi
	done
}

updates

pip2_updates

pip3_updates

_EOF_
	) > "${SCRIPTS}/update"
}

# /data/data/com.termux/files/home/.vimrc
write_vimrc () {
	if [[ -n "$(which vim)" ]]; then
		(
			cat <<- _EOF_
				:set number
				:set autoindent
				:set background=dark
				:syntax on
			_EOF_
		) > "${SCRIPTS}/vimrc"
	fi
}

# wrapper for git config
write_gitconfig () {
	output_status "${GREEN} * ${BLANK}Attempting to create ${GREEN}gitconfig${BLANK}..." 1
	
	if [[ -n "$(which git)" ]]; then
		username=$(_git_setup_prompt_ "username")
		email=$(_git_setup_prompt_ "email")
		editor=$(_git_setup_prompt_ "editor")

		git config --global user.name "$username"
		git config --global user.email "$email"
		git config --global core.editor "$editor"
	fi
}