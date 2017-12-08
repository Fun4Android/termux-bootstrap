#!/data/data/com.termux/files/usr/bin/env bash


echo_usage_notice () {
	echo -e "Usage:\n\t${PROGNAME} [command | [action]]\n\t${PROGNAME} [help | [command]]"
}


echo_usage_summary () {
cat << _EOF_
Usage:
    ${PROGNAME} [command] [action]
    ${PROGNAME} help [command]

Summary
-------
	${PROGNAME} installs all the base applications, scripts, and configuration files used for base development in Termux. This way you can do Bash, C, C++, python2, python3, or whatever your heart desires on the go.

	To display this page.
		-> help

	For detailed help on the [help] command.
		-> help help

	Print out a list of commands.
		-> help commands

	For more information about a command, follow the [help] command with a [command] name.
		-> help install
_EOF_
}


echo_usage_commands () {
cat << _EOF_
Commands are read as [short] | [long] | [description]
	[short] is the short command,
	[long] is the long command,
	[description] is a short description of the command

Commands
--------
	h | help
		Display this help text.

	i | install
		Installs base apps, scripts, and config files

	r | remove
		Removes base apps, scripts, and/or config files

	b | backup
		Backs up the current HOME directory

Actions
-------
	[ all  ]
		Installs all apps, scripts, config files, and symlinks.

	[ apps ]
		Installs the following applications using apt-get.

			make vim git gcc g++ gdb python2
			coreutils findutils grep
			man linux-man-pages
			openssh wget whois

	[ scripts ]
		Installs the following scripts and then symlinks them to the working environment. HOME/bin should be where your custom executables reside as well.

			bash.bashrc bash.aliases
			mkscript mkscript.config
			sudo patchme connect pylist	update
			vimrc gitconfig

	[ storage ]
		Symlinks created by termux-setup-storage. HOME/storage is where these symlinks will reside.

			dcim downloads movies
			music pictures shared
			external (only if extsdcard is present)

		All directories created by ${PROGNAME}. These will be placed as regular directories within your HOME directory.

			storage bin bash c cpp python
_EOF_
}


echo_usage_help() {
cat << _EOF_
Command -> help

For a list of all commands and actions.

	Usage
		-> help commands

For information about a specific command.

	Usage
		-> help [command]
_EOF_
}


echo_usage_install () {
cat << _EOF_
Command -> install -> remove

The [install] command takes 4 actions.
	Action
		all
		apps
		scripts
		storage

To install all selected apps, scripts, and symlinks.
	Usage
		-> install

			or
		-> install all

To install a specific subset by selection.
	Usage
		-> install apps

This will install all application using apt-get and will not install scripts or symlinks.

The [remove] command is the inverse of install, but should behave the same non-the-less.

For information about what is installed.
	Usage
		-> help commands
_EOF_
}


echo_usage_remove () {
	echo_usage_install
}


echo_usage_backup () {
cat << _EOF_
Command -> backup

The [backup] command takes no actions.
	Usage
		-> backup

The backup command creates an archive directory as ${HOME}/archive/

Each directory found within the HOME directory is archived and compressed and then moved to the archive directory.

There is currently no inverse operation available.

NOTE: This command does NOT remove any files! It just creates an archive snapshot of your current HOME directory.
_EOF_
}


echo_usage_clear() {
cat << _EOF_
Command -> clear

The [clear] command takes no actions.
	Usage
		-> clear

This command simply clears the screen.
_EOF_
}


echo_usage_quit() {
cat << _EOF_
Command -> quit -> bye

The [quit] command takes no actions.
	Usage
		-> quit

This command simply exits this program.
_EOF_
}


echo_usage () {
	if [[ -z "$1" ]];
		then action="help"
	else
		action="$1"
	fi

	case $action in
		commands)
			echo_usage_commands
			;;
		help)
			echo_usage_help
			;;
		install)
			echo_usage_install
			;;
		remove)
			echo_usage_remove
			;;
		backup)
			echo_usage_remove
			;;
		*)
			echo_usage_summary
			;;
	esac
}
