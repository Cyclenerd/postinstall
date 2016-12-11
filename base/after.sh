#
# after.sh for all OPERATING_SYSTEMs and TYPEs
#


#
# User Configuration
#

# Variable $MY_USERNAME is defined in /before.sh

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


#
# bashrc for root
#

# .profile or .bashrc
if [ -d "/root" ]; then
	echo_step "  Set .bashrc for root"
	if [ -f "/root/.bashrc" ]; then
		cp "/root/.bashrc" "/root/.bashrc.$OPERATING_SYSTEM"
	fi
	cat >> "/root/.bashrc" << EOF

# Set RED prompt
PS1='\[\033[01;31m\]\u@\h \[\033[01;34m\]\W # \[\033[00m\]'; export PS1

# Define nano as our default EDITOR
export EDITOR='nano'

export LC_CTYPE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

EOF
	echo_success
fi