# postinstall

Bash Script to automate post-installation steps.
Helps to install packages on different operating systems.

## Overview

`postinstall.sh` is simple bash shell script which in turn generates scripts.
The generation depends on the operating system and type of installation.
The templates that are included in the generation can be stored in the file system or on a web server.
This can also be your GitHub repository.

`postinstall.sh` is not a configuration management system.
If you want to install many servers automatically, you should look at [ansible](https://github.com/ansible/ansible).
But if you want to quickly reinstall your laptop or Raspberry Pi, `postinstall.sh` can help you.

### Program Flow

* Determine operating system and architecture
* Check package manager and requirements
* Generate script to run before and after installation and list of packages to install
* Install packages

### Generation

To generate the package lists and scrips, `postinstall.sh` looks at a number of places after configuration files.

* BASE
* BASE/HOSTNAME_FQDN
* BASE/TYPE
* BASE/OPERATING_SYSTEM
* BASE/OPERATING_SYSTEM/TYPE

Check out this repository to understand it better.

#### Example

Suppose you installed Fedora (Red Hat) Linux on your server with hostname (`HOSTNAME_FQDN`) `myserver.domain.local`.
So your operating system (`OPERATING_SYSTEM`) would be `REDHAT`.

The default type of installation (`TYPE`) is `server`.

If you now run `postinstall.sh` as root the following locations are tested:

Package list:

* /base/packages.list
* /base/__myserver.domain.local__/packages.list
* /base/__server__/packages.list
* /base/__REDHAT__/packages.list
* /base/__REDHAT__/__server__/packages.list

Before script:

* /base/before.sh
* /base/myserver.domain.local/before.sh
* /base/server/before.sh
* /base/REDHAT/before.sh
* /base/REDHAT/server/before.sh

After script:

* /base/after.sh
* /base/myserver.domain.local/after.sh
* /base/server/after.sh
* /base/REDHAT/after.sh
* /base/REDHAT/server/after.sh

When the generation has been completed, everything is started in the following order:

* Run before script
* Install packages
* Run after script

In our example this would be:

* Before
	* Get primary user group from user (`nils`)
	* Create private SSH key
* Packages
	* Several...
* After
	* SSH Daemon Configuration
	
If we change the type of installation (`postinstall.sh -t workstation`) to `workstation`, Spotify is installed:

* Before
	* Get primary user group from user (`nils`)
	* Create private SSH key
	* Installing RPM Fusion free and nonfree repositories
* Packages
	* Several... and Spotify
* After
	* Nothing

## Requirements

Only `bash`, `curl` and a package manager for the respective operating system:

* Cygwin  → `apt-cyg`
* Debian  → `apt-get`
* FreeBSD → `pkg`
* macOS   → `port` or `brew`
* Red Hat → `dnf` or `yum`
* SUSE    → `zypper`

## Usage

	Usage: postinstall [-t <TYPE>] [-b <BASE>] [-h]:
		[-t <TYPE>] sets the type of installation
		[-b <BASE>] sets the base url or dir
		[-h]        displays help

Example: `postinstall.sh` or `postinstall.sh -t workstation`

### TODO

* More and better documentation
* More tests
	* `brew` is currently not tested
* Support for even more operating systems (NetBSD, Arch Linux) and package managers

Help is welcome 👍

## License

GNU Public License version 3.
Please feel free to fork and modify this on GitHub (https://github.com/Cyclenerd/postinstall).