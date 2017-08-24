# postinstall.sh

[![Build Status](https://travis-ci.org/Cyclenerd/postinstall.svg?branch=master)](https://travis-ci.org/Cyclenerd/postinstall)

Bash Script to automate post-installation steps.
Helps to install packages on different operating systems.

![Apple macOS](https://www.nkn-it.de/img/distro/logos/apple-osx.png)
![Arch Linux](https://www.nkn-it.de/img/distro/logos/arch.png)
![CentOS](https://www.nkn-it.de/img/distro/logos/centos.png)
![Debian](https://www.nkn-it.de/img/distro/logos/debian.png)
![Fedora](https://www.nkn-it.de/img/distro/logos/fedora.png)
![FreeBSD](https://www.nkn-it.de/img/distro/logos/freebsd.png)
![OpenBSD](https://www.nkn-it.de/img/distro/logos/openbsd.png)
![Red Hat](https://www.nkn-it.de/img/distro/logos/redhat.png)
![SUSE](https://www.nkn-it.de/img/distro/logos/opensuse.png)
![Slackware](https://www.nkn-it.de/img/distro/logos/slackware.png)
![Ubuntu](https://www.nkn-it.de/img/distro/logos/ubuntu.png)
![Android](https://www.nkn-it.de/img/distro/logos/android.png)
![Termux](https://www.nkn-it.de/img/distro/logos/termux.png)

Cygwin and Haiku are also supported.

## Overview

`postinstall.sh` is simple bash shell script which in turn generates scripts.
The generation depends on the operating system and type of installation.
The templates that are included in the generation can be stored in the file system or on a web server.
This can also be your GitHub repository.
Just fork this repository and edit it according to your needs.

`postinstall.sh` is not a configuration management system.
If you want to install many servers automatically, you should look at [ansible](https://github.com/ansible/ansible).
But if you want to quickly reinstall your laptop or Raspberry Pi, `postinstall.sh` can help you.

__Please check the [Wiki](https://github.com/Cyclenerd/postinstall/wiki/postinstall.sh) for more information.__


## Installation

Download:

	curl -f https://raw.githubusercontent.com/Cyclenerd/postinstall/master/postinstall.sh -o postinstall.sh

Alternative download with short URL:

	curl -fL http://bit.ly/get_postinstall -o postinstall.sh

Run as root:

	bash postinstall.sh


## Usage

	Usage: postinstall [-t <TYPE>] [-b <BASE>] [-h]:
		[-t <TYPE>] sets the type of installation
		[-b <BASE>] sets the base url or dir
		[-h]        displays help

Example: `postinstall.sh` or `postinstall.sh -t workstation`


## Screenshot

![Fedora](http://i.imgur.com/cMm0GIe.gif)


## Program Flow

* Determine operating system and architecture
* Check package manager and requirements
* Generate script to run before and after installation and list of packages to install
* Install packages


## Requirements

Only `bash`, `curl` and a package manager for the respective operating system:

* Apple macOS               → `port` or `brew`
* Arch Linux                → `pacman`
* Cygwin                    → `apt-cyg`
* Debian / Ubuntu           → `apt-get`
* FreeBSD                   → `pkg`
* Haiku                     → `pkgman`
* OpenBSD                   → `pkg_add`
* Red Hat / Fedora / CentOS → `dnf` or `yum`
* Slackware                 → `slackpkg`
* SUSE / openSUSE           → `zypper`
* Termux                    → `pkg`


## TODO

* More and better documentation
* Support for even more operating systems (NetBSD, Gentoo Linux) and package managers

Help is welcome 👍


## License

GNU Public License version 3.
Please feel free to fork and modify this on GitHub (https://github.com/Cyclenerd/postinstall).