#
# after.sh for all OPERATING_SYSTEMs and TYPE=server
#

#
# Generate new SSH Daemon Keys
#

# SSH Daemon Configuration Directory, without / at the end
SSHD_KEY_DIR="/etc/ssh"
# Specifies the types of keys to create
SSHD_KEY_TYPES=("ed25519" "rsa")

if [ -d "$SSHD_KEY_DIR" ]; then
	echo_step "  Generating new SSH Daemon Keys in $SSHD_KEY_DIR (please wait)"; echo
	
	# Delete old keys
	rm "$SSHD_KEY_DIR"/ssh_host_*
	
	for SSHD_KEY_TYPE in ${SSHD_KEY_TYPES[*]}; do
		echo_step "    $SSHD_KEY_TYPE"
		echo -e "\nsshd key type $SSHD_KEY_TYPE" >>"$INSTALL_LOG"
		if [ "$SSHD_KEY_TYPE" == "rsa1" ]; then
			SSHD_KEY_FILE="ssh_host_key"
		else
			SSHD_KEY_FILE="ssh_host_"
			SSHD_KEY_FILE+="$SSHD_KEY_TYPE"
			SSHD_KEY_FILE+="_key"
		fi
		# Be advised that using keys stronger than 8192 bits with certificates will cause some versions of OpenSSH to ignore keys and fail.
		# Some older versions may even be limited to 4096 bits.
		echo -e 'y\n'|ssh-keygen -q -b 8192 -t "$SSHD_KEY_TYPE" -f "$SSHD_KEY_DIR/$SSHD_KEY_FILE" -N "" >>"$INSTALL_LOG" 2>&1
		if [ "$?" -ne 0 ]; then
			echo_warning "Failed, will attempt to continue"
		else
			echo_success
		fi
	done
fi


#
# SSH Daemon Configuration
#

SSHD_CONF_FILE="/etc/ssh/sshd_config"
SSHD_CONF_PORT="222"

if [ -f "$SSHD_CONF_FILE" ]; then
	echo_step "  Modifying SSH Daemon Configuration File at $SSHD_CONF_FILE"; echo
	
	cp "$SSHD_CONF_FILE" "$SSHD_CONF_FILE.$OPERATING_SYSTEM"
	
	echo_step "    Port 222"
	if grep -q ^#Port "$SSHD_CONF_FILE"; then
		perl -i -pe "s,^#Port.*,Port $SSHD_CONF_PORT,g" "$SSHD_CONF_FILE"
	else
		perl -i -pe "s,^Port.*,Port $SSHD_CONF_PORT,g" "$SSHD_CONF_FILE"
	fi
	if [ "$?" -ne 0 ]; then
		echo_warning "Failed, will attempt to continue"
	else
		echo_success
	fi
	
	echo_step "    Protocol 2"
	if grep -q ^#Protocol "$SSHD_CONF_FILE"; then
		perl -i -pe "s,^#Protocol.*,Protocol 2,g" "$SSHD_CONF_FILE"
	else
		perl -i -pe "s,^Protocol.*,Protocol 2,g" "$SSHD_CONF_FILE"
	fi
	if [ "$?" -ne 0 ]; then
		echo_warning "Failed, will attempt to continue"
	else
		echo_success
	fi
	
	echo_step "    PermitRootLogin no"
	if grep -q ^#PermitRootLogin "$SSHD_CONF_FILE"; then
		perl -i -pe "s,^#PermitRootLogin.*,PermitRootLogin no,g" "$SSHD_CONF_FILE"
	else
		perl -i -pe "s,^PermitRootLogin.*,PermitRootLogin no,g" "$SSHD_CONF_FILE"
	fi
	if [ "$?" -ne 0 ]; then
		echo_warning "Failed, will attempt to continue"
	else
		echo_success
	fi
fi







