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