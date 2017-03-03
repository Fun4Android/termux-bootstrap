# termux-bootstrap
Automates base installation and configuration for Termux

Note: This project is still under development and may cause issues within your
termux environment. If you find any bugs, fixes, or have any suggestions feel free
to contribute.

# synopsis 
When you first install Termux on your Andriod device, you're left with a barebones
set-up. 

This script installs all the common basic utilities and tools used for
basic and common dev tasks.

You can use this script on both rooted and non-rooted devices. 

The script will fail if you attempt to execute it as root so that you don't 
accidently change any local file permissions.

# install
	apt update
	apt install git
	git clone https://github.com/xovertheyearsx/termux-bootstrap
	cd termux-bootstrap
	./termux.bootstrap.sh

	
# usage
	Usage: $PROGNAME [ --help | --backup | --install | --remove ] [ all ]...

# summary
	$PROGNAME installs all the base applications, scripts, and configuration
	files used for base development in Termux. This way you can do Bash, C, 
	C++, python2, python3, or whatever your heart desires on the go.
		
	If you would like a full installation, just invoke $PROGNAME with the 
	install option.
	
		$PROGNAME --install all
		
	Likewise, if you would like a targeted installation type, just invoke 
	$PROGNAME with the desired option. The following statement below would 
	invoke installing the base applications in Termux.
		
		$PROGNAME --install apps
		
	The remove option achieves the inverse of install. That way you can 
	specify what you would like to remove. The following statement would 
	remove all directories created by the storage arugment.
		
		$PROGNAME --remove storage
			
	Whereas, invoking remove with the all argument would completely undo
	any action invoked by this script.
	
	NOTE: there are no arguments for the backup option.
	
		$PROGNAME --backup
		
	This will backup the entire HOME directory which is stored within a tar
	file. The tar file can be located within the ~/archive directory.

# options
	-h --help		Display this help text
		
	-i --install	Installs base apps, scripts, and config files
		
	-r --remove		Removes base apps, scripts, and/or config files
		
	-b --backup		Backs up the current HOME directory

# arguments
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