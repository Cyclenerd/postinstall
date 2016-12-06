#
# after.sh for ARCH and ALL types
#


#
# systemd-swap
#     https://www.archlinux.org/packages/?name=systemd-swap
#

SWAP_CONF_FILE="/etc/systemd/swap.conf"
echo_step "  Modifying systemd-swap configuration file at $SWAP_CONF_FILE"
if [ -f "$SWAP_CONF_FILE" ]; then
	# Backup
	cp "$SWAP_CONF_FILE" "$SWAP_CONF_FILE.$OPERATING_SYSTEM"
	# Disable Zswap
	perl -i -pe "s,^zswap_enabled.*,zswap_enabled=0,g" "$SWAP_CONF_FILE"
	# Disable ZRam
	perl -i -pe "s,^zram_enabled.*,zram_enabled=0,g" "$SWAP_CONF_FILE"
	# Disable Swap File Universal
	perl -i -pe "s,^swapfu_enabled.*,swapfu_enabled=0,g" "$SWAP_CONF_FILE"
	# Enable Swap File Chunked
	perl -i -pe "s,^swapfc_enabled.*,swapfc_enabled=1,g" "$SWAP_CONF_FILE"
	# Enable Swap devices
	perl -i -pe "s,^swapd_auto_swapon.*,swapd_auto_swapon=1,g" "$SWAP_CONF_FILE"
	# OK?
	if [ "$?" -ne 0 ]; then
		echo_warning "Failed, will attempt to continue"
	else
		echo_success
	fi
else
	echo_warning "$SWAP_CONF_FILE not found, will attempt to continue"
fi

echo_step "  Enable systemd-swap"
if systemctl enable systemd-swap >>"$INSTALL_LOG" 2>&1; then
	echo_success
else
	echo_warning "Failed, will attempt to continue"
fi

echo_step "  Start systemd-swap"
if systemctl start systemd-swap >>"$INSTALL_LOG" 2>&1; then
	echo_success
else
	echo_warning "Failed, will attempt to continue"
fi

#
# Set the swappiness
#     https://wiki.archlinux.org/index.php/Swap
#

echo_step "  Set the swappiness (vm.swappiness=10)"
echo "vm.swappiness=10" >> "/etc/sysctl.d/99-sysctl.conf"
echo_success
