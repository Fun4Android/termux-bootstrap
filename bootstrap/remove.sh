#!/data/data/com.termux/files/usr/bin/env bash

#
# PRIVATE FUNCTIONS
#

# handle missing bash directory
_handle_bash_directory_ () {		
	if [[ ! -d "$ARCHIVE" ]]; then
		output_status "${RED} * Error${BLANK}: Missing ~/bash directory..." 1
		
		echo "Exiting now."
		
		exit $DIR_ERROR
	fi
}

# handle bash.bashrc symlink
_handle_bash_symlink_ () {
	# make sure bash.bashrc is symlinked
	if [[ -L ${ETC}/bash.bashrc ]]; then 
		rm -v ${ETC}/bash.bashrc
	fi
}

# handle missing bash.bashrc file
_handle_bash_bashrc_ () {	
	# check if backup is present
	if [[ -e "${ETC}/bash.bashrc.backup" ]]; then
		output_status "${GREEN} * ${BLANK} Restored original bash.bashrc file..." 1
		
		mv -v ${ETC}/bash.bashrc.backup ${ETC}/bash.bashrc
	
	# if backup is missing, check if auto-generated script is present
	elif [[ -e ${ARCHIVE}/bash.bashrc ]]; then
		output_status "${YELLOW} * Exception${BLANK}: Missing bash.bashrc.backup file..." 1
		
		mv -v ${ARCHIVE}/bash.bashrc ${ETC}/bash.bashrc
	
	# else refuse to leave bash configuration unhandled
	else
		output_status "${RED} * Error${BLANK}: Missing bash.bashrc file..." 1
		
		echo "Exiting now."
		
		exit $FILE_ERROR
	fi
}

#
# PUBLIC FUNCTIONS
#

# remove core packages using apt
remove_apps () {
	output_status "${GREEN} * ${BLANK}Using ${GREEN}apt${BLANK} to remove base packages..." 1
	
	apt remove make vim git gcc g++ gdb python2 \
	coreutils findutils grep \
	man linux-man-pages \
	openssh wget whois -y
	
	apt autoremove
	
	apt autoclean
}

# remove core scripts
remove_scripts () {
	output_status "${GREEN} * ${BLANK}Removing core scripts..." 1

	# if ~/bash is missing, there is nothing to do
	_handle_bash_directory_
	
	# if bash.bashrc is a symlink, remove it
	_handle_bash_symlink_
	
	# attempt to restore original bash.bashrc file
	_handle_bash_bashrc_
	
	# remove core scripts
	rm -v ${ARCHIVE}/* ${BIN}/* .bash.aliases .vimrc .gitconfig	
}

# wrapper for removing HOME directories
remove_local_storage () {
	output_status "${GREEN} * ${BLANK}Removing HOME directories..." 1
	
	# if bash.bashrc is a symlink, remove it
	_handle_bash_symlink_
	
	# attempt to restore original bash.bashrc file
	_handle_bash_bashrc_
	
	# create base directory structure for HOME dir
	rm -rv ${HOME}/bin ${HOME}/python ${HOME}/c ${HOME}/cpp \
	${HOME}/bash ${HOME}/storage
}

#
# PRIMARY FUNCTION (used in parent script)
#

# execute install action
remove () {
	local action="$1"
	
	case "$action" in
		all)
			remove_apps
			
			remove_scripts
			
			remove_local_storage
			
			;;
			
		apps)
			remove_apps

			;;
			
		scripts)
			remove_scripts

			;;
			
		storage)
			remove_local_storage

			;;
			
		*)
			echo_usage_notice
			
			exit $FAILURE
			;;	
	esac
}