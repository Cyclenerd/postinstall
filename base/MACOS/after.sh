#
# after.sh for MACOS and all TYPEs
#

#
# Trigger a Notification Center notification from an AppleScript
#

echo_step "  Trigger a Notification Center notification"
osascript -e 'display notification "Installation completed 👍   "' 2>&1
if [ "$?" -ne 0 ]; then
	echo_warning "Failed to trigger notification, will attempt to continue"
else
	echo_success
fi



