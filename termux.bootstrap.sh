#!/data/data/com.termux/files/usr/bin/env bash
#
# termux.bootstrap.sh
#
# 	Automates base installation and configuration for Termux environment
#

# log the program name
PROGNAME="$(basename $0)"

# set exit codes
FAILURE=1
FILE_ERROR=2
DIR_ERROR=4
PERM_ERROR=8
ENV_ERROR=16

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

clear

check_if_root

check_environment

echo -e "Type ${GREEN}help${BLANK} for more information."
echo -e "\t${GREEN}Usage"
echo -e "\t\t${RED}-${BLANK}> ${GREEN}help${BLANK}"

while true; do
	cmd=
	action=

	read -ep "-> " cmd action

	case $cmd in
		h|help)
			echo_usage "$action"
			;;
		b|backup)
			backup_home_dir
		
			output_status "${GREEN} * Successful backup.${BLANK}"
			;;
		i|install)
			install "$action"
		
			output_status "${GREEN} * Successful installation.${BLANK}"
			;;
		r|remove)
			remove "$action"
		
			output_status "${GREEN} * Successful removal.${BLANK}"
			;;

		c|clear)
			clear
			;;

		q|quit|bye)
			echo "Bye."
			break
			;;
		*)
			echo -e "Command: $cmd\tAction: $action"
			echo_usage_notice
			;;
	esac
done