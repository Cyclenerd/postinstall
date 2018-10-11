#
# after.sh for DEBIAN and ALL types
#


#
# Set the swappiness
#    https://en.wikipedia.org/wiki/Swappiness
#

echo_step "  Set the swappiness (vm.swappiness=10)"
echo "vm.swappiness=10" >> "/etc/sysctl.conf"
echo_success

#
# Edit motd
#

echo_step "  Edit motd"
chmod -x "/etc/update-motd.d/10-help-text" >>"$INSTALL_LOG" 2>&1
chmod -x "/etc/update-motd.d/50-motd-newst" >>"$INSTALL_LOG" 2>&1
chmod -x "/etc/update-motd.d/80-livepatch" >>"$INSTALL_LOG" 2>&1
echo_success