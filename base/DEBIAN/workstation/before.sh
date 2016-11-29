#
# before.sh for DEBIAN and TYPE=workstation
#

# Add the Spotify repository signing key to be able to verify downloaded packages
echo_step "  Installing Spotify repository signing key"
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 >>"$INSTALL_LOG" 2>&1
if [ "$?" -ne 0 ]; then
	echo_warning "Failed to install signing key, will attempt to continue"
else
	echo_success
fi

# Add the Spotify repository
echo_step "  Installing Spotify repository"
echo "deb http://repository.spotify.com stable non-free" | tee "/etc/apt/sources.list.d/spotify.list" >>"$INSTALL_LOG" 2>&1
if [ "$?" -ne 0 ]; then
	echo_warning "Failed to install repositories, will attempt to continue"
else
	echo_success
fi

# Update list of available packages
echo_step "  Update list of available packages"
apt-get update >>"$INSTALL_LOG" 2>&1
if [ "$?" -ne 0 ]; then
	echo_warning "Failed to install repositories, will attempt to continue"
else
	echo_success
fi