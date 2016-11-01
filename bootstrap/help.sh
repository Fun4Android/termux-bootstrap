#!/data/data/com.termux/files/usr/bin/env bash

echo_usage_notice () {
	echo "Usage: $PROGNAME [ --help | --install | --remove ] [ all ]..."
}

echo_usage_summary () {
	cat <<- _EOF_
		Usage: $PROGNAME [ --help | --install | --remove ] [ all ]...

		Summary
		-------
		$PROGNAME installs all the base applications, scripts, and configuration
		files used for base development in Termux. This way you can do Bash, C, 
		C++, python2, python3, or whatever your heart desires on the go.
		
		If you would like a full installation, just invoke $PROGNAME with the 
		install option.
		
			\$ $PROGNAME --install all
		
		Likewise, if you would like a targeted installation type, just invoke 
		$PROGNAME with the desired option. The following statement below would 
		invoke installing the base applications in Termux.
		
			\$ $PROGNAME --install apps
		
		The remove option achieves the inverse of install. That way you can 
		specify what you would like to remove. The following statement would 
		remove all directories created by the storage arugment.
		
			\$ $PROGNAME --remove storage
			
		Whereas, invoking remove with the all argument would completely undo
		any action invoked by this script.

		Options
		-------
		-h --help		Display this help text
		
		-i --install	Installs base apps, scripts, and config files
		
		-r --remove		Removes base apps, scripts, and/or config files

		Arguments
		---------
		[ all  ]		All apps, scripts, and config files
		
		[ apps ]		All applications installed by $PROGNAME
							make vim git gcc g++ gdb python2
							coreutils findutils grep
							man linux-man-pages
							openssh wget whois

		[ scripts ] 	All scripts installed by $PROGNAME
							bash.bashrc bash.aliases
							mkscript mkscript.config
							sudo patchme connect pylist	update
							vimrc gitconfig

		[ storage ]		All symlinks created by termux-setup-storage
							dcim downloads movies
							music pictures shared
							external (only if extsdcard is present)
							
						All directories created by $PROGNAME
							storage bin bash c cpp python
	_EOF_
}
