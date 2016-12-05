#
# after.sh for all OPERATING_SYSTEMs and TYPEs
#

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