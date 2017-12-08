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
    ./termux.bootstrap.sh help

# usage
    $ pwd
    /data/data/com.termux/files/home/termux-bootstrap
    $ ls -l
    total 56
    drwxr-xr-x 2 th3ros th3ros  4096 Nov 29 23:57 bootstrap
    -rw-r--r-- 1 th3ros th3ros 18046 Nov 26  2016 LICENSE
    -rw-r--r-- 1 th3ros th3ros  2902 Nov 26  2016 README.md
    drwxr-xr-x 2 th3ros th3ros  4096 Nov 30 00:37 scripts
    -rwxr-xr-x 1 th3ros th3ros  2162 Nov 30 19:37 termux.bootstrap.sh
    $ ./termux.bootstrap.sh
    Usage:
        termux.bootstrap.sh [command] [action]
        termux.bootstrap.sh help [command]
    $ ./termux.bootstrap.sh help
    Command -> help

    For a list of all commands and actions.

    	Usage
    		-> help commands

    For information about a specific command.

            Usage
    		-> help [command]

    # USAGE
    $ ./termux.bootstrap.sh help usage | less
    ...press q to quit less...
    
    # COMMANDS
    $ ./termux.bootstrap.sh help commands | less
    ...press q to quit less...
    
    # FULL INSTALL
    $ ./termux.bootstrap.sh install all
    ...prints actions to standard output...

    # PARTIAL INSTALL
    # sometimes after a playstore update, the environment will be in a broken state
    # to restore the previous config state, just do a partial install
    $ ./termux.bootstrap.sh install scripts

# summary
termux.bootstrap.sh installs all the base applications, scripts, and configuration files used for base development in Termux. This way you can do Bash, C, C++, python2, python3, or whatever your heart desires on the go.
		
If you would like a full installation, just invoke termux.bootstrap.sh with the install option.
	
    $ termux.bootstrap.sh install all
		
Likewise, if you would like a targeted installation type, just invoke termux.bootstrap.sh with the desired option. The following statement below would invoke installing the base applications in Termux.
		
    $ termux.bootstrap.sh install apps
		
The remove option achieves the inverse of install. That way you can specify what you would like to remove. The following statement would remove all directories created by the storage arugment.
		
    $ termux.bootstrap.sh remove storage
			
Whereas, invoking remove with the all argument would completely undo any action invoked by this script.
	
**NOTE**: there are no arguments for the backup option.
	
    $ termux.bootstrap.sh backup
		
This will backup the entire HOME directory which is stored within a tar file. The tar file can be located within the `~/archive` directory.

# options
    h help		Display this help text
		
    i install	Installs base apps, scripts, and config files
		
    r remove	Removes base apps, scripts, and/or config files
		
    b backup	Backs up the current HOME directory

# arguments
    [ all  ]	All apps, scripts, and config files
		
    [ apps ]	All applications installed by termux.bootstrap.sh
				make vim git gcc g++ gdb python2
				coreutils findutils grep
				man linux-man-pages
				openssh wget whois

    [ scripts ]	All scripts installed by termux.bootstrap.sh
    			bash.bashrc bash.aliases
				mkscript mkscript.config
				sudo patchme connect pylist update
				vimrc gitconfig

    [ storage ]	All symlinks created by termux-setup-storage
    			dcim downloads movies
				music pictures shared
				external (only if extsdcard is present)
							
			All directories created by termux.bootstrap.sh
				storage bin bash c cpp python
