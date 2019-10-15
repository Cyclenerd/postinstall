#
# before.sh for DEBIAN and TYPE=workstation
#

# Add user's .ssh directory
echo_step "  Make user's .ssh"
mkdir -p "$(getent passwd "$MY_USERNAME" | cut -d: -f6)/.ssh"
if [ "$?" -ne 0 ]; then
	echo_warning "Failed to create, will attempt to continue"
else
	echo_success
fi
