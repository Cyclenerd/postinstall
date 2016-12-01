#
# before.sh for OPENBSD and all TYPEs
#

#
# Search last screen version and remember for installation
#
# OpenBSD has two screen flavors:
#        static - Build with statically linked binaries.
#        shm - export screen as shared memory, useful for brltty.
#
# During the installation you have to specify the __exact__ version.
#
# I want the static version
#
echo_step "  Search last screen version"
if SCREEN_VERSION=$(curl -fs "http://ftp.eu.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -p)/" | sed -En 's/.*>(screen-.*[0-9]).tgz.*/\1/p'); then
	echo_step_info "$SCREEN_VERSION"
	echo "$SCREEN_VERSION" >> $PACKAGES_LIST
	echo_success
else
	echo_warning "Failed, will attempt to continue"
fi

#
# Search last mutt version without flavor and remember for installation
#
echo_step "  Search last mutt version"
if MUTT_VERSION=$(curl -fs "http://ftp.eu.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -p)/" | sed -En 's/.*>(mutt-.*[0-9]).tgz.*/\1/p'); then
	echo_step_info "$MUTT_VERSION"
	echo "$MUTT_VERSION" >> $PACKAGES_LIST
	echo_success
else
	echo_warning "Failed, will attempt to continue"
fi