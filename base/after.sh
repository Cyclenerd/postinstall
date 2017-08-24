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
	echo -e "\n test dir /Users/$MY_USERNAME"
	echo -e "\n test dir /data/data/com.termux/files/home"
	echo -e "\n test dir /home/$MY_USERNAME"
	echo -e "\n test file ~$MY_USERNAME/.ssh/id_rsa"
	echo -e "\n test dir ~$MY_USERNAME"
} >>"$INSTALL_LOG"
# macOS
if [ -d "/Users/$MY_USERNAME" ]; then	
	export HOMEDIR="/Users/$MY_USERNAME"
# Termux
elif [ -d "/data/data/com.termux/files/home" ]; then
	export HOMEDIR="/data/data/com.termux/files/home"
# *nix
else
	export HOMEDIR="/home/$MY_USERNAME"
fi
if [ -f "$HOMEDIR/.ssh/id_rsa" ]; then
	echo_warning "'SSH key already exists, will not generate new ones'"
elif [ -d "$HOMEDIR" ]; then
	{
		echo -e "\n mkdir $HOMEDIR/.ssh"
		mkdir "$HOMEDIR/.ssh"
		echo -e "\n ssh-keygen" >>"$INSTALL_LOG"
		echo -e 'y\n'|ssh-keygen -q -t rsa -b 4096 -f "$HOMEDIR/.ssh/id_rsa" -N ""
	} >>"$INSTALL_LOG" 2>&1
	if [ "$?" -ne 0 ]; then
		echo_warning "Failed, will attempt to continue"
	else
		{
			echo -e "\n chown -R $MY_USERNAME:$MY_PRIMARY_GROUP $HOMEDIR/.ssh"
			chown -R "$MY_USERNAME":"$MY_PRIMARY_GROUP" "$HOMEDIR/.ssh"
			echo -e "\n chmod 700 $HOMEDIR/.ssh"
			chmod 700 "$HOMEDIR/.ssh"
			echo -e "\n chmod 600 $HOMEDIR/.ssh/id_rsa"
			chmod 600 "$HOMEDIR/.ssh/id_rsa "
		} >>"$INSTALL_LOG" 2>&1
		echo_success
	fi
else
	echo_warning "Failed, will attempt to continue"
fi


#
# bashrc for root
#

if [ -d "/root" ]; then
	echo_step "  Set .bashrc for root"
	if [ -w "/root" ]; then
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
	else
		echo_warning "Can not write to /root, will attempt to continue"
	fi
fi