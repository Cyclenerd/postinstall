# Termux

Termux is an Android terminal app and Linux environment.

## Using Package Management

Termux uses `apt` and `dpkg` for package management, similar to Ubuntu or Debian.

More details can be found at https://wiki.termux.com/wiki/Package_Management

### Installing packages

Make sure the local package index cache is up-to-date by running:

`apt update`

To install apache2 web server:

`apt install apache2`

Or you can use pkg wrapper, which updates the package cache before installing:

`pkg install apache2`

Manually downloaded .deb files can be installed using:

`apt install ./apache2_2.4.26_arm.deb`

or directly using dpkg:

`dpkg -i ./apache2_2.4.26_arm.deb`