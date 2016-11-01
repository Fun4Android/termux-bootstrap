#!/data/data/com.termux/files/usr/bin/env bash
#
# PRIVATE FUNCTIONS
#

# update python modules using pip
_install_pip_updates_ () {
	if [[ -n "$(which pip2)" ]]; then
		local pip_bin=$(which pip2)
	else
		local pip_bin=$(which pip)
	fi

	output_status "${GREEN} * ${BLANK}Attempting to update '${GREEN}${pip_bin}${BLANK}'..." 1
	
	local pip_pkg=$($pip_bin list | cut -d ' ' -f 1)
	
	if [[ -n "$pip_bin" && -n "$pip_pkg" ]]; then
		"$pip_bin" install --upgrade "$pip_pkg"
	fi
}

# create required directories for script install
_require_dirs_ () {
	output_status "${GREEN} * ${BLANK}Checking to see if ${GREEN}archive${BLANK} and ${GREEN}bin${BLANK} dirs exist..." 1
	
	# make sure archive dir exits in HOME
	if [[ ! -d ${ARCHIVE} ]]; then
		mkdir -v ${ARCHIVE}
	fi
		
	# make sure bin dir exists in HOME
	if [[ ! -d ${BIN} ]]; then
		mkdir -v ${BIN}
	fi
}

# archive all scripts to ~/archive/termux
_install_archive_ () {
	output_status "${GREEN} * ${BLANK}Populating archive with base scripts..." 1

	# copy mkscript to ARCHIVE if SCRIPTS existed
	if [[ -n "$MKSCRIPT" ]]; then
		cp -v ${SCRIPTS}/mkscript ${ARCHIVE}/
		cp -v ${SCRIPTS}/mkscript.config ${ARCHIVE}/
	fi
	
	# archive the scripts
	for filename in ${SCRIPTS}/*; do
		# do NOT move mkscript or vimrc to archive
		if [[ "$filename" =~ ^mkscript || "vimrc" == "$filename" ]]; then
			continue
		fi
		
		mv -v ${SCRIPTS}/${filename} ${ARCHIVE}/
	done
}

# symlink all scripts from ~/archive/termux
_install_symlinks_ () {
	output_status "${GREEN} * ${BLANK}Populating termux with symlinks..." 1

	ln -vs ${ARCHIVE}/bash.bashrc ${ETC}/bash.bashrc
	ln -vs ${ARCHIVE}/bash.aliases ${HOME}/.bash.aliases
	
	for filename in ${ARCHIVE}/*; do
		# bash config files have unique locations
		if [[ "$filename" =~ ^bash ]]; then
			continue
		fi
		
		ln -vs ${ARCHIVE}/${filename} ${BIN}/${filename}
	done
}

#
# PUBLIC FUNCTIONS
#

# update termux and install core apps using apt
install_applications () {
	output_status "${GREEN} * ${BLANK}Using ${GREEN}apt${BLANK} to update and upgrade..." 1
	
	apt update && apt upgrade -y

	output_status "${GREEN} * ${BLANK}Using ${GREEN}apt${BLANK} to install core packages..." 1
	
	apt install make vim git gcc g++ gdb python2 \
	coreutils findutils grep \
	man linux-man-pages \
	openssh wget whois -y
	
	_install_pip_updates_
}

# wrapper for writing scripts/configs to disk
write_scripts () {
	output_status "${GREEN} * ${BLANK}Attempting to write core scripts to disk..." 1
	
	# if the scripts dir is missing, assume mkscript is missing too
	if [[ ! -d "${SCRIPTS}" ]]; then
		MKSCRIPT=""
		mkdir -v "$SCRIPTS"
	fi
	
	_write_bash_bashrc
	_write_bash_aliases
	_write_patchme
	_write_pylist
	_write_update
	_write_vimrc
	_write_gitconfig
	
	# only if user has rooted device
	if [[ -n "$(which su)" ]]; then
		_write_sudo
	fi
}

# wrapper for creating HOME directories
setup_local_storage () {
	output_status "${GREEN} * ${BLANK}Creating HOME directories..." 1

	# creates ~/storage with symlinks to internal and external sdcards
	termux-setup-storage

	# create base directory structure for HOME dir
	mkdir -v ${HOME}/bin ${HOME}/python ${HOME}/c ${HOME}/cpp \
	${HOME}/bash ${HOME}/storage ${HOME}/archive
}

# wrapper for installing scripts
install_scripts () { 
	output_status "${GREEN} * Installing base scripts...${BLANK}" 1

	# create BIN and ARCHIVE dirs if missing
	_require_dirs_
	
	# backup original bash.bashrc file
	mv -v ${ETC}/bash.bashrc ${ETC}/bash.bashrc.backup
	
	# copy/move generated scripts to ~/archive/termux
	_install_archive_
	
	# symbolically link scripts to ~/bin from ~/archive/termux
	_install_symlinks_
	
	# general configs reside in HOME
	mv -v ${SCRIPTS}/vimrc ${HOME}/.vimrc
}

#
# PRIMARY FUNCTION (used in parent script)
#

# execute install action
install () {
	local action="$1"
	
	case "$action" in
		all)
			install_applications
			
			write_scripts
			
			install_scripts
			
			setup_local_storage

			;;
			
		apps)
			install_applications

			;;
			
		scripts)
			install_scripts

			;;
			
		storage)
			setup_local_storage

			;;
			
		*)
			echo_usage_notice
			
			exit $FAILURE
			;;	
	esac
}