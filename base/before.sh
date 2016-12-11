#
# before.sh for all OPERATING_SYSTEMs and TYPEs
#


#
# User Configuration
#

export MY_USERNAME='nils'
export MY_USERNAME_COMMENT='Nils K.'

# Check if user exists, if not create user and add to group wheel (for sudo)
if id -u "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1; then
	echo -e "\nuser $MY_USERNAME found" >>"$INSTALL_LOG"
else
	echo -e "\ncreate new user $MY_USERNAME" >>"$INSTALL_LOG"
	echo_step "  Create user"
	echo_step_info "$MY_USERNAME"
	case $OPERATING_SYSTEM in
		ARCH)
			if command_exists useradd; then
				if useradd --shell "/bin/bash" --password "paqemd8ny15g2" --comment "$MY_USERNAME_COMMENT" --create-home --user-group "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1; then
					if grep "wheel" /etc/group >> "$INSTALL_LOG" 2>&1; then
						usermod -a -G wheel "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1
					fi
					echo_success
				else
					echo_warning "User '$MY_USERNAME' could not be created, will attempt to continue"
				fi
			else
				echo_warning "Command 'useradd' not found, will attempt to continue"
			fi
			;;
		DEBIAN)
			if command_exists adduser; then
				if adduser --shell "/bin/bash" --disabled-password --gecos "$MY_USERNAME_COMMENT" --quiet "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1; then
					if grep "wheel" /etc/group >> "$INSTALL_LOG" 2>&1; then
						usermod -a -G wheel "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1
					fi
					echo_success
				else
					echo_warning "User '$MY_USERNAME' could not be created, will attempt to continue"
				fi
			else
				echo_warning "Command 'adduser' not found, will attempt to continue"
			fi
			;;
		REDHAT)
			if command_exists adduser; then
				if adduser --shell "/bin/bash" --password "paqemd8ny15g2" --comment "$MY_USERNAME_COMMENT" --create-home --user-group "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1; then
					if grep "wheel" /etc/group >> "$INSTALL_LOG" 2>&1; then
						usermod -a -G wheel "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1
					fi
					echo_success
				else
					echo_warning "User '$MY_USERNAME' could not be created, will attempt to continue"
				fi
			else
				echo_warning "Command 'adduser' not found, will attempt to continue"
			fi
			;;
		SUSE)
			if command_exists useradd; then
				if useradd --shell "/bin/bash" --password "paqemd8ny15g2" --comment "$MY_USERNAME_COMMENT" --create-home --user-group "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1; then
					if grep "wheel" /etc/group >> "$INSTALL_LOG" 2>&1; then
						usermod -a -G wheel "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1
					fi
					echo_success
				else
					echo_warning "User '$MY_USERNAME' could not be created, will attempt to continue"
				fi
			else
				echo_warning "Command 'useradd' not found, will attempt to continue"
			fi
			;;
		FREEBSD)
			if command_exists pw; then
				if pw user add "$MY_USERNAME" -s "/usr/local/bin/bash" -m -c "$MY_USERNAME_COMMENT" -q >> "$INSTALL_LOG" 2>&1; then
					if grep "wheel" /etc/group >> "$INSTALL_LOG" 2>&1; then
						pw groupmod wheel -m "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1
					fi
					echo_success
				else
					echo_warning "User '$MY_USERNAME' could not be created, will attempt to continue"
				fi
			else
				echo_warning "Command 'pw' not found, will attempt to continue"
			fi
			;;
		*)
			echo -e "\n No USERADD option for OS '$OPERATING_SYSTEM'" >>"$INSTALL_LOG"
			echo_warning "User '$MY_USERNAME' could not be created, will attempt to continue"
			;;
	esac
	
	if id -u "$MY_USERNAME" >> "$INSTALL_LOG" 2>&1; then
		echo_step "  Change password"
		echo
		echo -e "\n passwd $MY_USERNAME" >>"$INSTALL_LOG"
		passwd "$MY_USERNAME"
		echo
	fi
fi


	
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