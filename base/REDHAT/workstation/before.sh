#
# before.sh for REDHAT and TYPE=workstation
#

# Add RPMFusion for ffmpeg-libs
echo_step "  Installing RPM Fusion free and nonfree repositories"
$MY_INSTALLER $MY_INSTALL "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
	"https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" >>"$INSTALL_LOG" 2>&1
if [ "$?" -ne 0 ]; then
	echo_warning "Failed to install repositories, will attempt to continue"
else
	echo_success
fi

# Add negativo17.org for spotify-client
echo_step "  Installing negativo17.org repositories for Spotify"

dnf config-manager --add-repo="https://negativo17.org/repos/fedora-spotify.repo" >>"$INSTALL_LOG" 2>&1
if [ "$?" -ne 0 ]; then
	echo_warning "Failed to install repositories, will attempt to continue"
else
	echo_success
fi