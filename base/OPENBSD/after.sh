#
# after.sh for OPENBSD and all TYPEs
#


# Download and load new PF (Firewall) ruleset
# PF is enabled by default. If you wish to disable it on boot, use the rcctl tool to do so:
#   rcctl disable pf

cp "/etc/pf.conf" "/etc/pf.conf.$OPERATING_SYSTEM"

# Download /etc/pf.conf
echo_step "  Download new PF (Firewall) ruleset"
echo -e "\n $FETCHER $BASE/$OPERATING_SYSTEM/pf.conf -o /etc/pf.conf" >>"$INSTALL_LOG"
$FETCHER "$BASE/$OPERATING_SYSTEM/pf.conf" -o "/etc/pf.conf"
if [ "$?" -ne 0 ]; then
	echo_warning "Failed, will attempt to continue"
else
	echo_success
fi

# Load new ruleset
echo_step "  Load the pf.conf file"
echo -e "\n pfctl -f /etc/pf.conf" >>"$INSTALL_LOG"
pfctl -f "/etc/pf.conf" >>"$INSTALL_LOG" 2>&1
if [ "$?" -ne 0 ]; then
	echo_warning "Failed, will attempt to continue"
else
	echo_success
fi


# Build htop from source
# Check out the latest version at the project page
# https://hisham.hm/htop/releases/
HTOP_RELEASE="2.0.2"

echo_step "  Build htop from source"
curl -sf "https://hisham.hm/htop/releases/$HTOP_RELEASE/htop-$HTOP_RELEASE.tar.gz" -o "/tmp/htop.tar.gz"
if [ -f "/tmp/htop.tar.gz" ]; then
	{
		gunzip "/tmp/htop.tar.gz"
		mkdir "/tmp/htop"
		tar -xvf "/tmp/htop.tar" -C "/tmp/htop"
		cd /tmp/htop/htop*/ || return
		./configure -q
		make
		make install
		cd ~- || return
	} >>"$INSTALL_LOG" 2>&1
else
	echo_warning "Failed to download, will attempt to continue"
fi
if command_exists htop; then
	echo_success
else
	echo_warning "Failed to build, will attempt to continue"
fi