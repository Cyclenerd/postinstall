# OpenBSD

Bash is not included in the default installation. Instead, OpenBSD uses `ksh` as the default shell.

So you have to install Bash.

## Using pkg_add for Binary Package Management

pkg_add_ is the OpenBSD package management tool.
More details can be found at http://man.openbsd.org/pkg_add

### Install bash

	# pkg_add -I bash
	# ln -s /usr/local/bin/bash /bin/bash

### Install curl

	# pkg_add -I curl