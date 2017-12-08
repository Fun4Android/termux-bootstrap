#!/data/data/com.termux/files/usr/bin/env bash

#
# PRIVATE FUNCTIONS
#

# handle missing bash directory
_handle_bash_directory_ () {
	if [[ ! -d "$ARCHIVE" ]];
        then
		output_status "${RED} * Error${BLANK}: Missing ~/bash directory..." 1
		echo "Exiting now."
		exit $DIR_ERROR
	fi
}

# handle bash.bashrc symlink
_handle_bash_symlink_ () {
    local bashrc="bash.bashrc"
    local aliases="bash.aliases"

	# make sure bash.bashrc is symlinked
	if [[ -L ${ETC}/${bashrc} ]];
        then rm -v ${ETC}/${bashrc}
	fi

    if [[ -L ${ETC}/${aliases} ]];
        then rm -v ${ETC}/${aliases}
    fi
}

# handle missing bash.bashrc file
_handle_bash_bashrc_ () {
    local bashrc=bash.bashrc
    local skeleton=bash.bashrc.skeleton
    local aliases=bash.aliases

	# check if original is present
	if [[ -e "${ARCHIVE}/${skeleton}" ]];
        then
		output_status "${GREEN} * ${BLANK} Restored original ${bashrc} file..." 1
		mv -v ${ARCHIVE}/${skeleton} ${ETC}/${bashrc}

	# if original is missing, check if auto-generated script is present
    elif [[ -e ${ARCHIVE}/${bashrc} ]];
        then
		output_status "${YELLOW} * Exception${BLANK}: Missing ${skeleton} file..." 1
		mv -v ${ARCHIVE}/${bashrc} ${ETC}/${bashrc}
        mv -v ${ARCHIVE}/${aliases} ${ETC}/${aliases}

	# else refuse to leave bash configuration unhandled
	else
		output_status "${RED} * Error${BLANK}: Missing ${bashrc} file..." 1
	fi
}

#
# PUBLIC FUNCTIONS
#

# remove core packages using apt
remove_apps () {
	output_status "${GREEN} * ${BLANK}Using ${GREEN}apt${BLANK} to remove base packages..." 1

	apt remove \
    make vim git clang gdb \
    coreutils findutils grep \
    man linux-man-pages \
    openssh wget -y

    if [[ "2" == "${PYTHON_VERSION}" ]];
        then apt remove python2 -y
    elif [[ "3" == "${PYTHON_VERSION}" ]];
        then apt remove python -y
    elif [[ "both" == "${PYTHON_VERSION}" ]];
        then apt remove python python2 -y
    fi

	apt autoremove -y
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
	rm -v ${ARCHIVE}/* ${BIN}/* ${HOME}/.vimrc ${HOME}/.gitconfig ${HOME}/.viminfo
}

# wrapper for removing HOME directories
remove_local_storage () {
	output_status "${GREEN} * ${BLANK}Removing HOME directories..." 1

	# if bash.bashrc is a symlink, remove it
	_handle_bash_symlink_

	# attempt to restore original bash.bashrc file
	_handle_bash_bashrc_

	# create base directory structure for HOME dir
	rm -rv \
    ${HOME}/archive ${HOME}/bash ${HOME}/bin \
    ${HOME}/c ${HOME}/cpp ${HOME}/python \
	${HOME}/storage
}

#
# PRIMARY FUNCTION (used in parent script)
#

# execute install action
remove () {
	local action="$1"

	case "$action" in
		all)
			remove_scripts
			remove_local_storage
            remove_apps
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
			;;
	esac
}
