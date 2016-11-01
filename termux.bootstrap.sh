#!/data/data/com.termux/files/usr/bin/env bash
#
# termux.bootstrap.sh -- Automates base installation and configuration for Termux 
#
# outline:
# 	termux.bootstrap [ --help | --install | --remove ] [ all ]...
#		termux.bootstrap --install all -> full install
#	
# 	Automates base installation and configuration for Termux environment
#

# log the program name
PROGNAME="$(basename $0)"

# set positional parameters
OPTION="$1"
ACTION="$2"

# set exit codes
SUCCESS=0
FAILURE=1
FILE_ERROR=2
DIR_ERROR=3
PERM_ERROR=4
ENV_ERROR=5

source_files () {
	for filename in "$@"; do
		filepath="./bootstrap/${filename}"
		
		if [[ -s "${filepath}" ]]; then
			source "${filepath}"	
		else
			echo -e "Error: missing '${filename}'.\nExiting now."
			exit $FILE_ERROR
		fi
		
		shift
	done
}

# sources must be loaded in this exact order !
source_files "config.sh" "help.sh" "scripts.sh" "install.sh" "remove.sh"

main () { # main program
	case "$OPTION" in
		-h|--help)
			echo_usage_summary

			exit $SUCCESS
			;;
		-b|--backup)
			backup_home_dir
			
			exit $SUCCESS
			;;
		-i|--install)
			install "$ACTION"
			
			output_status "${GREEN} * Installation Successful. Done.${BLANK}"
			
			exit $SUCCESS
			;;
		-r|--remove)
			remove "$ACTION"
			
			exit $SUCCESS
			;;
		
		*)
			echo_usage_notice

			exit $SUCCESS
			;;
	esac
}

# TEST IF EXECUTED AS ROOT
check_if_root

# VALIDATE ENV VARIABLES
check_environment

# CALL MAIN PROGRAM
main
