#!/data/data/com.termux/files/usr/bin/env bash

# SET GLOBAL VARIABLES

# termux and bootstrap filepaths
ETC=${PREFIX}/etc
BIN=${HOME}/bin
ARCHIVE=${HOME}/bash
SCRIPTS=${PWD}/scripts

# termux environment variables
environ=($HOME $PREFIX $LD_LIBRARY_PATH)

# base scripts
scripts=("bash.bashrc" "bash.aliases" "sudo" "mkscript" "mkscript.config" \
"patchme" "connect" "pylist" "update" "vimrc")

# custom utility for creating skeleton scripts for bash
MKSCRIPT="true"

# put a little color in your life
YELLOW='\033[1;33m' # used as indicator
GREEN='\033[1;32m'  # used as informational
RED='\033[1;31m'    # used as error
BLANK='\033[1;00m'  # reset prompt color

# SET GLOBAL FUNCTIONS

#
# PRIVATE FUNCTIONS
#

# prompt for git config
_git_setup_prompt_ () {
	REPLY=""
	local NOUN="$1"

	while [[ -z "$REPLY" ]]; do
		read -p " * Enter your ${NOUN} for git: "
	done

	echo "$REPLY"
}

# tests environment variables
_check_var_status_ () {
	local variable="$1"
	local value="$2"
	if [[ -z "$value" ]]; then
		echo -e "${RED} * Error${BLANK}: variable '${RED}${variable}${BLANK}' contains an unset value..."
		exit $ENV_ERROR
		
	elif [[ ! -d "$value" ]]; then
		echo -e "${RED} * Error${BLANK}: variable '${RED}${variable}${BLANK}' does not contain a valid file path..."
		exit $DIR_ERROR
		
	else
		echo -e "${GREEN} * Environment Variable${BLANK}: '${variable}'... ${GREEN}ok${BLANK}."
		
	fi
}

#
# PUBLIC FUNCTIONS
#

# echo status to stdout
output_status () {
	local string="$1"
	local delay="$2"

	if [[ -z "$string" ]]; then
			echo -e "${RED} * Error${BLANK}: missing string argument for function ${RED}output_status${BLANK}..."
			echo "Exiting now."
			exit $FAILURE
	fi
	
	if [[ -z "$delay" ]]; then
		delay=0
	fi
	
	echo
	echo -e "$string"
	
	sleep $delay
}

# wrapper for testing env variables
check_environment () {
	output_status "${GREEN} * ${BLANK}Checking environment variables..." 1

	_check_var_status_ "HOME" "$HOME"

	_check_var_status_ "PREFIX" "$PREFIX"

	_check_var_status_ "LD_LIBRARY_PATH" "$LD_LIBRARY_PATH"
}

# check if user is executing as root
#
# 	if user is root, kill script (always check for root uid!!!)
# 	if run as root, permissions issues will devour your time and energy
#
check_if_root () {
	output_status "${YELLOW} * NEVER RUN THIS SCRIPT AS SUPER USER!${BLANK}" 1
	
	if (( 0 == $UID )); then
		echo
		
		cat <<- _EOF_
			${RED} * Error${BLANK}: You should never run system functions as ${RED}root${BLANK}
			in Termux. If you do, you risk breaking your environment.
			
			Exiting now.
		_EOF_

		exit $PERM_ERROR
	fi

}

backup_home_dir () {
	output_status "${GREEN} * ${BLANK}Backing up and archiving HOME directory..." 1
	
	if [[ ! -d ${HOME}/archive ]]; then
		mkdir -v ${HOME}/archive
	fi
	
	for directory in ${HOME}/*; do
		if [[ "archive" == ${directory##*/} || "termux" == ${directory##*/} ]]; then
			continue
		fi
		
		if [[ -d "$directory" ]]; then
				tar czvf ${HOME}/${directory##*/}.tar.gz $directory
				mv -v ${HOME}/${directory##*/}.tar.gz ${HOME}/archive
		fi
	done
}