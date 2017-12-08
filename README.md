# contents
1. [termux-bootstrap](https://github.com/xovertheyearsx/termux-bootstrap#termux-bootstrap)
2. [synopsis](https://github.com/xovertheyearsx/termux-bootstrap#synopsis)
3. [install](https://github.com/xovertheyearsx/termux-bootstrap#install)
4. [usage](https://github.com/xovertheyearsx/termux-bootstrap#usage)
5. [summary](https://github.com/xovertheyearsx/termux-bootstrap#summary)
6. [options](https://github.com/xovertheyearsx/termux-bootstrap#options)
7. [arguments](https://github.com/xovertheyearsx/termux-bootstrap#arguments)
8. [environment](https://github.com/xovertheyearsx/termux-bootstrap#environment)

# termux-bootstrap
Automates base installation and configuration for [Termux](https://termux.com/)

Note: This project is still under development and may cause issues within your
termux environment. If you find any bugs, fixes, or have any suggestions feel free
to contribute.

# synopsis 
When you first install [Termux](https://termux.com/) on your Andriod device, you're left with a barebones
set-up. 

This script installs all the common basic utilities and tools used for
basic and common dev tasks.

You can use this script on both rooted and non-rooted devices. 

The script will fail if you attempt to execute it as root so that you don't 
accidently change any local file permissions.

# install
```bash
# update apt and install git
$ apt update
$ apt install git -y
# download the repo and enter the directory
$ git clone https://github.com/xovertheyearsx/termux-bootstrap.git
$ cd termux-bootstrap
# For help
$ ./termux.bootstrap.sh help
# For full install
$ ./termux.bootstrap.sh install
# For full backup
$ ./termux.bootstrap.sh backup
# For full removal - note that sometimes the python2 links can become remnants
# You can control which version of python gets installed by modifying the global variable $PYTHON_VERSION
# You can find the $PYTHON_VERSION variable in the termux.bootstrap.sh source file
$ ./termux.bootstrap.sh remove
```

**WARNING**: be sure to move the `archive` directory somewhere safe before issuing the removal command!

# usage
```bash
$ pwd
/data/data/com.termux/files/home/termux-bootstrap
$ ls -l
total 56
drwxr-xr-x 2 u0_a74 u0_a74  4096 Nov 29 23:57 bootstrap
-rw-r--r-- 1 u0_a74 u0_a74 18046 Nov 26  2016 LICENSE
-rw-r--r-- 1 u0_a74 u0_a74  2902 Nov 26  2016 README.md
drwxr-xr-x 2 u0_a74 u0_a74  4096 Nov 30 00:37 scripts
-rwxr-xr-x 1 u0_a74 u0_a74  2162 Nov 30 19:37 termux.bootstrap.sh
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
```

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

# environment
After installing termux using google playstore, using termux-bootstrap to configure your environment, and installing `tree` using `apt`, you can get glimpse of the directory and file structure.

```bash
$ apt install tree
$ tree $HOME
.
├── archive
├── bash
│   ├── bash.aliases
│   ├── bash.bashrc
│   ├── bash.bashrc.default
│   ├── bash.bashrc.skeleton
│   ├── mkscript
│   ├── mkscript.config
│   ├── patchme
│   ├── pylist
│   ├── sudo
│   ├── update
│   └── vimrc
├── bin
│   ├── mkscript -> /data/data/com.termux/files/home/bash/mkscript
│   ├── mkscript.config -> /data/data/com.termux/files/home/bash/mkscript.config
│   ├── patchme -> /data/data/com.termux/files/home/bash/patchme
│   ├── pylist -> /data/data/com.termux/files/home/bash/pylist
│   ├── sudo -> /data/data/com.termux/files/home/bash/sudo
│   └── update -> /data/data/com.termux/files/home/bash/update
├── c
├── cpp
├── python
├── storage
│   ├── dcim -> /storage/emulated/0/DCIM
│   ├── downloads -> /storage/emulated/0/Download
│   ├── movies -> /storage/emulated/0/Movies
│   ├── music -> /storage/emulated/0/Music
│   ├── pictures -> /storage/emulated/0/Pictures
│   └── shared -> /storage/emulated/0
└── termux-bootstrap
    ├── LICENSE
    ├── README.md
    ├── bootstrap
    │   ├── config.sh
    │   ├── help.sh
    │   ├── install.sh
    │   └── remove.sh
    ├── scripts
    │   ├── bash.aliases
    │   ├── bash.bashrc
    │   ├── bash.bashrc.default
    │   ├── mkscript
    │   ├── mkscript.config
    │   ├── patchme
    │   ├── pylist
    │   ├── sudo
    │   ├── update
    │   └── vimrc
    └── termux.bootstrap.sh

16 directories, 34 files
```
- `bin` and `storage` contain links to active scripts and directories. 
- `bash` has all your scripts. 
- any scripts that you'd like to use can then be linked to `bin` making them globally available within the termux. 
- by default, scripts are executable. you can write up a quick one liner to change this.
- symbolic links to `bash.bashrc` and `bash.aliases` can be found by using `cd ${PREFIX}/etc`
- you can customize your `bash.bashrc` and `bash.aliases` configuration files using `vim ~/bash/bash.bashrc ~/bash/bash.aliases`

```bash
for script in ${HOME}/bash/*; do if [[ -f "$script" ]]; then chmod -vr 0644 "$script"; fi; done
```

this will make all scripts within the `bash` directory non-executable.

**NOTE**: never delete the `bash` directory! termux-bootstrap depends on the `bash` and `archive` directories. the `archive` directory should speak for it self. should you ever want to backup anything, including your environment, you can do so using this directory.

**WARNING**: be sure to move the `archive` directory somewhere safe before issuing the removal command!

**NOTE**: You can always just use termux-bootstrap to automate the backup process for you. Make sure to double check that everything is as expected before officially removing anything by backing it up in the cloud, your local storage, external sd-card, etc. etc.
