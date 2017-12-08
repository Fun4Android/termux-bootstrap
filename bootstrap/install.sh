#!/data/data/com.termux/files/usr/bin/env bash
#
# PRIVATE FUNCTIONS
#

# update python modules using pip
_install_pip2_updates_ () {
    output_status "${GREEN} * ${BLANK}Attempting to update '${GREEN}pip2${BLANK}'..." 1

    if [[ -n "$(which pip2)" ]];
        then
        pip2 install --upgrade pip

        pip_pkg="$(pip2 list -o --format=legacy | cut -d ' ' -f 1)"

        if [[ -n "$pip_pkg" ]];
            then pip2 install --upgrade $pip_pkg
        fi
    fi
}


_install_pip_updates_ () {
    output_status "${GREEN} * ${BLANK}Attempting to update '${GREEN}pip3${BLANK}'..." 1

    if [[ -n "$(which pip3)" ]];
        then
        pip3 install --upgrade pip

        pip_pkg=$(pip3 list -o --format=legacy | cut -d ' ' -f 1)

        if [[ -n "$pip_pkg" ]];
            then pip3 install --upgrade "$pip_pkg"
        fi
    fi
}


# create required directories for script install
_require_dirs_ () {
    output_status "${GREEN} * ${BLANK}Checking to see if ${GREEN}archive${BLANK} and ${GREEN}bin${BLANK} dirs exist..." 1

    # make sure archive dir exits in HOME
    if [[ ! -d ${ARCHIVE} ]];
        then mkdir ${ARCHIVE}
    fi

    # make sure bin dir exists in HOME
    if [[ ! -d ${BIN} ]];
        then mkdir ${BIN}
    fi
}


# archive all scripts to ~/archive/termux
_install_archive_ () {
    output_status "${GREEN} * ${BLANK}Populating archive with base scripts..." 1

    # copy scripts to user environment
    for script in ${SCRIPTS}/*;
        do cp "$script" ${ARCHIVE}/
    done

    # make scripts executable by default
    for script in ${ARCHIVE}/*;
        do chmod 0764 "$script"
    done
}


# symlink all scripts from ~/archive/termux
_install_symlinks_ () {
    output_status "${GREEN} * ${BLANK}Populating termux with symlinks..." 1

    ln -s ${ARCHIVE}/vimrc ${HOME}/.vimrc

    ln -s ${ARCHIVE}/bash.bashrc ${ETC}/bash.bashrc
    ln -s ${ARCHIVE}/bash.aliases ${ETC}/bash.aliases

    if [[ -n "$(which python2)" && -z "$(which python3)" ]];
        then
        ln -s ${PREFIX}/bin/python2 ${PREFIX}/bin/python
        ln -s ${PREFIX}/bin/pip2 ${PREFIX}/bin/pip
    fi

    for filepath in ${ARCHIVE}/*;
        do
        local filename=${filepath##*/}

        # some config files have unique locations
        # this avoids potential conflicts
        if [[ "$filename" =~ ^bash || "$filename" == vimrc ]];
            then continue
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
    apt-get -qq install \
    make vim git clang gdb \
    coreutils findutils grep \
    man linux-man-pages \
    openssh wget -y

    if [[ "2" == "${PYTHON_VERSION}" ]];
        then apt-get -qq install python2 -y
    elif [[ "3" == "${PYTHON_VERSION}" ]];
        then apt-get -qq install python -y
    elif [[ "both" == "${PYTHON_VERSION}" ]];
        then apt-get -qq install python python2 -y
    fi

    _install_pip_updates_
    _install_pip2_updates_
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


# wrapper for git config
git_config () {
    output_status "${GREEN} * ${BLANK}Attempting to create ${GREEN}gitconfig${BLANK}..." 1

    if [[ -n "$(which git)" ]]; then
        username=$(_git_setup_prompt_ "username")
        email=$(_git_setup_prompt_ "email")
        editor=$(_git_setup_prompt_ "editor")

        git config --global user.name "$username"
        git config --global user.email "$email"
        git config --global core.editor "$editor"
    fi
}


# wrapper for installing scripts
install_scripts () {
    output_status "${GREEN} * Installing base scripts...${BLANK}" 2

    # create BIN and ARCHIVE dirs if missing
    _require_dirs_

    # backup original bash.bashrc file
    if [[ -f ${ETC}/bash.bashrc ]];
        then mv ${ETC}/bash.bashrc ${ARCHIVE}/bash.bashrc.skeleton
    fi

    # copy/move generated scripts to ~/archive/termux
    _install_archive_

    # symbolically link scripts to ~/bin from ~/archive/termux
    _install_symlinks_

    # configure git
    git_config
}


#
# PRIMARY FUNCTION (used in parent script)
#

# execute install action
install () {
    local action="$1"

    if [[ -z "$action" ]];
        then action="all"
    fi

    case "$action" in
        all)
            install_applications
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
            ;;
    esac
}
