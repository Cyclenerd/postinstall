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
