#
# after.sh for MACOS and all TYPEs
#


#
# Set system defaults for macOS
#    https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#

echo_step "  Set system defaults for macOS"

# Disable the sound effects on boot
nvram SystemAudioVolume=" "

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

# Never go into computer sleep mode
systemsetup -setcomputersleep Off > /dev/null

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
systemsetup -settimezone "Europe/Berlin" > /dev/null

# Show the /Volumes folder
chflags nohidden /Volumes

# Kill affected applications
for app in "Dock" "Finder"; do
	killall "${app}" &> /dev/null
done

echo_success


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



