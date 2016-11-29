# FreeBSD

Bash is not included in the default installation. Instead, FreeBSD uses `tcsh` as the default root shell, and the Bourne shell-compatible `sh` as the default user shell.
Generally shell scripts written for `sh` will run in Bash, but the reverse is not always true.

So you have to install Bash.

## Using pkg for Binary Package Management

pkg is the FreeBSD package management tool.
More details can be found at https://www.freebsd.org/doc/handbook/pkgng-intro.html

### Getting Started with pkg

FreeBSD includes a bootstrap utility which can be used to download and install pkg, along with its manual pages.

To bootstrap the system, run:

	# /usr/sbin/pkg

For earlier FreeBSD versions, pkg must instead be installed from the Ports Collection or as a binary package.

To install the port, run:

	cd /usr/ports/ports-mgmt/pkg
	make
	make install clean

### Install bash

	# pkg install bash
	# ln -s /usr/local/bin/bash /bin/bash

### Install curl

	# pkg install curl