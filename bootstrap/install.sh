#!/data/data/com.termux/files/usr/bin/env bash
#
# PRIVATE FUNCTIONS
#

# update python modules using pip
_install_pip2_updates_ () {
	output_status "${GREEN} * ${BLANK}Attempting to update '${GREEN}pip2${BLANK}'..." 1
	
	if [[ -n "$(which pip2)" ]]; then	
		pip2 install -U pip
		
		pip_pkg="$(pip2 list -o | cut -d ' ' -f 1)"
		
		if [[ -n "$pip_pkg" ]]; then
			pip2 install -U $pip_pkg
		fi
	fi
}

_install_pip_updates_ () {
	output_status "${GREEN} * ${BLANK}Attempting to update '${GREEN}pip${BLANK}'..." 1
	
	if [[ -n "$(which pip)" ]]; then	
		pip install -U pip
		
		pip_pkg=$(pip list -o | cut -d ' ' -f 1)
		
		if [[ -n "$pip_pkg" ]]; then
			pip install --upgrade "$pip_pkg"
		fi
	fi	
}

# create required directories for script install
_require_dirs_ () {
	output_status "${GREEN} * ${BLANK}Checking to see if ${GREEN}archive${BLANK} and ${GREEN}bin${BLANK} dirs exist..." 1
	
	# make sure archive dir exits in HOME
	if [[ ! -d ${ARCHIVE} ]]; then
		mkdir ${ARCHIVE}
	fi
		
	# make sure bin dir exists in HOME
	if [[ ! -d ${BIN} ]]; then
		mkdir ${BIN}
	fi
}

# archive all scripts to ~/archive/termux
_install_archive_ () {
	output_status "${GREEN} * ${BLANK}Populating archive with base scripts..." 1

	# copy mkscript to ARCHIVE if SCRIPTS existed
	if [[ -n "$MKSCRIPT" ]]; then
		cp ${SCRIPTS}/mkscript ${ARCHIVE}/
		cp ${SCRIPTS}/mkscript.config ${ARCHIVE}/
	fi
	
	# archive the scripts
	for filepath in ${SCRIPTS}/*; do
		local filename=${filepath##*/}
		# do NOT move mkscript or vimrc to archive
		if [[ "$filename" =~ ^mkscript || "vimrc" == "$filename" ]]; then
			continue
		fi
		
		mv "$filepath" ${ARCHIVE}/
	done
}

# symlink all scripts from ~/archive/termux
_install_symlinks_ () {
	output_status "${GREEN} * ${BLANK}Populating termux with symlinks..." 1

	ln -s ${ARCHIVE}/bash.bashrc ${ETC}/bash.bashrc
	ln -s ${ARCHIVE}/bash.aliases ${HOME}/.bash.aliases
	
	for filepath in ${ARCHIVE}/*; do
		local filename=${filepath##*/}
		
		# bash config files have unique locations
		if [[ "$filename" =~ ^bash ]]; then
			continue
		fi
		
		ln -s "$filepath" "${BIN}/${filename}"
	done
}

#
# PUBLIC FUNCTIONS
#

# update termux and install core apps using apt
install_applications () {
	output_status "${GREEN} * Using apt to update and upgrade...${BLANK}" 2
	
	apt-get -qq update && apt-get -qq upgrade -y

	output_status "${GREEN} * Using apt to install core packages...${BLANK}" 2
	
	# whois is available via busybox
	# clang replaces gcc and g++ (gcc and g++ are deprecated)
	# https://github.com/termux/termux-packages/issues/407
	apt-get -qq install make vim git clang gdb python2 \
	coreutils findutils grep \
	man linux-man-pages \
	openssh wget -y
	
	_install_pip_updates_
	_install_pip2_updates_
}

# wrapper for writing scripts/configs to disk
write_scripts () {
	output_status "${GREEN} * Attempting to write core scripts to disk...${BLANK}" 2
	
	# if the scripts dir is missing, assume mkscript is missing too
	if [[ ! -d "${SCRIPTS}" ]]; then
		MKSCRIPT=""
		mkdir "$SCRIPTS"
	fi
	
	write_bash_bashrc
	write_bash_aliases
	write_patchme
	write_pylist
	write_update
	write_vimrc
	write_gitconfig
	
	# only if user has rooted device
	if [[ -n "$(which su)" ]]; then
		write_sudo
	fi
}

# wrapper for creating HOME directories
setup_local_storage () {
	output_status "${GREEN} * Creating HOME directories...${BLANK}" 2

	# creates ~/storage with symlinks to internal and external sdcards
	termux-setup-storage

	# create base directory structure for HOME dir
	mkdir ${HOME}/bin ${HOME}/python ${HOME}/c ${HOME}/cpp \
	${HOME}/bash ${HOME}/archive
}

# wrapper for installing scripts
install_scripts () { 
	output_status "${GREEN} * Installing base scripts...${BLANK}" 2

	# create BIN and ARCHIVE dirs if missing
	_require_dirs_
	
	# backup original bash.bashrc file
	mv -v ${ETC}/bash.bashrc ${ARCHIVE}/bash.bashrc.original
	
	# copy/move generated scripts to ~/archive/termux
	_install_archive_
	
	# symbolically link scripts to ~/bin from ~/archive/termux
	_install_symlinks_
	
	# general configs reside in HOME
	mv ${SCRIPTS}/vimrc ${HOME}/.vimrc
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
			
			setup_local_storage
			
			install_scripts

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