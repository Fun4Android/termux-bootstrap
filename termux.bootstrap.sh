#!/data/data/com.termux/files/usr/bin/env bash
#
# termux.bootstrap.sh
#
# 	Automates base installation and configuration for Termux environment
#

# SET GLOBAL VARIABLES

# log the program name
declare -r PROGNAME="$(basename $0)"

# set exit codes
declare -r FAILURE=1
declare -r FILE_ERROR=2
declare -r DIR_ERROR=4
declare -r PERM_ERROR=8
declare -r ENV_ERROR=16

# termux and bootstrap filepaths
declare -r ETC=${PREFIX}/etc
declare -r BIN=${HOME}/bin
declare -r ARCHIVE=${HOME}/bash
declare -r SCRIPTS=${PWD}/scripts

# put a little color in your life
declare -r YELLOW='\033[1;33m' # used as indicator
declare -r GREEN='\033[1;32m'  # used as informational
declare -r RED='\033[1;31m'    # used as error
declare -r BLANK='\033[1;00m'  # reset prompt color

# termux environment variables
declare -ra environ=($HOME $PREFIX $LD_LIBRARY_PATH)

# determine which python version is installed
#   value can be "2", "3", or "both"; "2" is the default value
# if you do not want python
#   leave empty PYTHON_VERSION= or as empty qoute PYTHON_VERSION=""
# python2 is considered deprecated as of the year 2020
declare PYTHON_VERSION="2"


function source_files () {
	for filename in "$@";
        do
		filepath="${PWD}/bootstrap/${filename}"

		if [[ -s "${filepath}" ]];
            then source "${filepath}"
		else
			echo -e "Error: '${filename}' is missing or corrupt.\nExiting now."
			exit $FILE_ERROR
		fi

		shift
	done
}

# sources must be loaded in this exact order !
source_files "config.sh" "help.sh" "install.sh" "remove.sh"

cmd="$1"
action="$2"

case $cmd in
	h|help)
		echo_usage "$action"
		;;

	b|backup)
        check_if_root
        check_environment
		backup_home_dir
		output_status "${GREEN} * Successful backup.${BLANK}"
		;;

	i|install)
        check_if_root
        check_environment
		install "$action"
		output_status "${GREEN} * Successful installation.${BLANK}"
		;;
	r|remove)
        check_if_root
        check_environment
		remove "$action"
		output_status "${GREEN} * Successful removal.${BLANK}"
		;;

	# c|clear)
	# 	clear
	# 	;;
    #
	# q|quit|e|exit|bye)
	# 	echo "Bye."
	# 	break
	# 	;;

	*)
		echo_usage_notice
		;;
esac
