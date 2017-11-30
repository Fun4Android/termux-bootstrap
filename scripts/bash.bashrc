#
# /data/data/com.termux/files/usr/etc/bash.bashrc
#
command_not_found_handle() {
	/data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
}

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# source termux env variables for bash
HOME=/data/data/com.termux/files/home
PREFIX=/data/data/com.termux/files/usr
LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib
ALIASES=${PREFIX}/etc/bash.aliases

# source the bin path for home directory
if [[ -d ${HOME}/bin ]];
    then PATH=${HOME}/bin:${PATH}
fi

# set the python path
if [[ -d ${HOME}/python ]];
    then PYTHONPATH=${HOME}/python:${PYTHONPATH}
fi

# enable colorful terminal -- see note
# note:
# different devices may have different base configurations.
# use the 'find' command to locate it (you may need su installed
# depending on your device). for example, as a normal user,
# 	$ find / ! -readable -prune -o -print -type f | grep bash | less

use_color=true

if [[ ${EUID} == 0 ]] ;
    then PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
	PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \W \$\[\033[00m\] '
fi

# export environmental paths
export HOME PREFIX PATH LD_LIBRARY_PATH PYTHONPATH PS1

# source aliases for bash
if [[ -L ${ALIASES} || -f ${ALIASES} ]];
    then source ${ALIASES}
fi

unset ALIASES use_color
