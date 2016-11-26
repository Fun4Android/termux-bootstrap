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
			echo -e "Error: '${filename}' is missing or corrupt.\nExiting now."
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
			
			exit
			;;
		-b|--backup)
			check_if_root

			check_environment

			backup_home_dir
			
			output_status "${GREEN} * Successful backup.${BLANK}"
			
			exit
			;;
		-i|--install)
			check_if_root

			check_environment

			install "$ACTION"
			
			output_status "${GREEN} * Successful installation.${BLANK}"
			
			exit
			;;
		-r|--remove)
			check_if_root

			check_environment

			remove "$ACTION"
			
			output_status "${GREEN} * Successful removal.${BLANK}"

			exit
			;;
		
		*)
			echo_usage_notice
			
			exit
			;;
	esac
}

# CALL MAIN PROGRAM
main
