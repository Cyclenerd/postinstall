#
# before.sh for all OPERATING_SYSTEMs and TYPEs
#


#
# User Configuration
#

export MY_USERNAME='nils'

# Get primary user group from user
echo_step "  Get primary user group from user"
echo_step_info "$MY_USERNAME"
echo -e "\nid -gn $MY_USERNAME" >>"$INSTALL_LOG"
if id -gn "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1; then
	MY_PRIMARY_GROUP=$(id -gn "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1)
	export MY_PRIMARY_GROUP
	echo "primary user group from user $MY_USERNAME is $MY_PRIMARY_GROUP" >>"$INSTALL_LOG"
	echo_success
else
	echo_warning "User '$MY_USERNAME' does not exist, will attempt to continue"
fi

# Create private SSH key
echo_step "  Creating private SSH key"
echo_step_info "~$MY_USERNAME/.ssh/id_rsa"
{
	echo -e "\n test dir /home/$MY_USERNAME"
	echo -e "\n test dir /Users/$MY_USERNAME"
	echo -e "\n test file ~$MY_USERNAME/.ssh/id_rsa"
	echo -e "\n test dir ~$MY_USERNAME"
} >>"$INSTALL_LOG"
if [ -d "/Users/$MY_USERNAME" ]; then
	# macOS
	export HOMEDIR="/Users"
else
	# *nix
	export HOMEDIR="/home"
fi
if [ -f "$HOMEDIR/$MY_USERNAME/.ssh/id_rsa" ]; then
	echo_warning "'SSH key already exists, will not generate new ones'"
elif [ -d "$HOMEDIR/$MY_USERNAME" ]; then
	{
		echo -e "\n mkdir $HOMEDIR/$MY_USERNAME/.ssh"
		mkdir $HOMEDIR/$MY_USERNAME/.ssh
		echo -e "\n ssh-keygen" >>"$INSTALL_LOG"
		echo -e 'y\n'|ssh-keygen -q -t rsa -b 4096 -f "$HOMEDIR/$MY_USERNAME/.ssh/id_rsa" -N ""
	} >>"$INSTALL_LOG" 2>&1
	if [ "$?" -ne 0 ]; then
		echo_warning "Failed, will attempt to continue"
	else
		{
			echo -e "\n chown -R $MY_USERNAME:$MY_PRIMARY_GROUP $HOMEDIR/$MY_USERNAME/.ssh"
			chown -R "$MY_USERNAME":"$MY_PRIMARY_GROUP" "$HOMEDIR/$MY_USERNAME/.ssh"
			echo -e "\n chmod 700 $HOMEDIR/$MY_USERNAME/.ssh"
			chmod 700 "$HOMEDIR/$MY_USERNAME/.ssh"
			echo -e "\n chmod 600 $HOMEDIR/$MY_USERNAME/.ssh/id_rsa"
			chmod 600 "$HOMEDIR/$MY_USERNAME/.ssh/id_rsa "
		} >>"$INSTALL_LOG" 2>&1
		echo_success
	fi
else
	echo_warning "Failed, will attempt to continue"
fi