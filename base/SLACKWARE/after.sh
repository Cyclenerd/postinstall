#!/bin/bash
#
#
# after.sh for SLACKWARE and all TYPEs
#
# Copyright (c) 2017 Cristiano Urban (https://crish4cks.net)
#
# This script automatically retrieves and installs the kernel
# patches on Slackware, creates the initrd and writes a basic
# configuration in /etc/lilo.conf.
#
# 'kernel-patches' must be used in combination with slackpkg, thus
# you have to launch 'slackpkg update' and 'slackpkg upgrade-all'
# before to run it.
#
# Features:
#
# *) Automatic detection, retrieve and installation of the packages
# *) Automatic initrd creation
# *) Possibility to choose for a manual or automatic LILO configuration
# *) The automatic LILO configuration creates a basic entry in lilo.conf
#    with the possibility to append parameters
#
# In order to upgrade a SMP kernel you need to pass the SMP_KERNEL
# parameter:
#
#     SMP_KERNEL=yes ./kernel-patches
#
# This will create the initrd for the SMP kernel.
#
#
# Version 0.4
#
sed -i '17,25 s/^/#/' /etc/slackpkg/blacklist


# Title for dialog boxes
DIALOG_TITLE="Slackware kernel patches"

# Temporary work dir
TMP=${TMP:-/tmp/kernel-patches}

# Use the same mirror of slackpkg (removes empty lines, if any + the slash at the end)
MIRROR=$(cat /etc/slackpkg/mirrors | grep -v '#' | sed 's/ //g' | sed 's/.$//')

# Extract the protocol type from the mirror URL
MIRROR_TYPE=$(echo $MIRROR | cut -d':' -f 1)

# Determine the system architecture (ARM not supported for now)
if [ -z "$ARCH" ]; then
  case "$( uname -m )" in
    i?86) ARCH=i586 ;;
       *) ARCH=$( uname -m ) ;;
  esac
fi

# Check if MIRROR is empty
if [ -z "$MIRROR" ]; then
  dialog --title "${DIALOG_TITLE}" \
         --clear \
         --msgbox "\nNo mirror selected for slackpkg! \n\nPlease, select one mirror from /etc/slackpkg/mirrors \nand launch slackpkg before." 10 58
  exit
fi

dialog --title "${DIALOG_TITLE}" \
       --clear \
       --yesno "\n\nWould you like to check if new patches are available?" 10 40

case $? in
  0)
    :;;
  1)
    exit;;
  255)
esac

dialog --backtitle "${DIALOG_TITLE}" \
       --infobox "\n\nChecking for updates..." 7 30

# The current running kernel version
KERN_OLD=$(uname -r)

# Determine the new kernel version
pattern='linux-[0-9]{1}.[0-9]{1,2}.[0-9]{1,3}'

if [ "$MIRROR_TYPE" == "ftp" ]; then
  KERN_DIR=$(curl -l -s ${MIRROR}/patches/packages/ | egrep -o $pattern)
else
  KERN_DIR=$(curl -s ${MIRROR}/patches/packages/ | grep -Po '(?<=href=")[^"]*' | egrep -o $pattern)
fi

KERN_NEW=${KERN_DIR:6}

# Support for SMP kernel
if [[ "${SMP_KERNEL:-no}" = "yes" && "$ARCH" != "x86_64" ]]; then
  SMP="-smp"
else
  SMP=""
fi

# Compare the kernel versions
if [ "$KERN_OLD" != "${KERN_NEW}${SMP}" ]; then
  dialog --title "${DIALOG_TITLE}" \
         --clear \
         --yesno "\n\nNew kernel version available: ${KERN_NEW}\n\nDo you want to proceed?" 10 45

  case $? in
    0)
      :;;
    1)
      exit;;
    255)
  esac

  dialog --backtitle "${DIALOG_TITLE}" \
         --infobox "\n\nDownloading the packages..." 7 35
  sleep 2

  # Create a temporary work dir
  mkdir -p $TMP

  # Two cases: ftp or http(s)
  if [ "$MIRROR_TYPE" == "ftp" ]; then
    # From the list, get the elements ending with .txz (the packages), then exclude kernel-firmware and kernel-headers
    PKGS=$(curl -l -s ${MIRROR}/patches/packages/${KERN_DIR}/ | grep -Po '.{1,}txz$' | grep -v 'firmware\|headers')
  else
    # Get the http response (html code)
    HTTP_RESPONSE=$(curl $MIRROR/patches/packages/${KERN_DIR}/)
    # Find the links, get the ones ending with .txz (the packages), then exclude kernel-firmware and kernel-headers
    PKGS=$(echo $HTTP_RESPONSE | grep -Po '(?<=href=")[^"]*' | grep -Po '.{1,}txz$'| grep -v 'firmware\|headers')
  fi

  # Download all the packages (don't clobber the files already present)
  for i in $PKGS
  do
    wget -nc ${MIRROR}/patches/packages/${KERN_DIR}/${i} -P $TMP
  done

  dialog --title "${DIALOG_TITLE}" \
         --clear \
         --yesno "\n\nAll packages have been downloaded.\nWould you like to proceed with the upgrade?" 10 40

  case $? in
    0)
      :;;
    1)
      exit;;
    255)
  esac

  # Install the packages
  set -e
  installpkg ${TMP}/kernel-*-${KERN_NEW}*.txz

  dialog --backtitle "${DIALOG_TITLE}" \
         --infobox "\n\nCreating the initrd..." 7 30
  sleep 2

  # Create the initrd
  $(/usr/share/mkinitrd/mkinitrd_command_generator.sh -k ${KERN_NEW}${SMP} -a "-o /boot/initrd-${KERN_NEW}${SMP}.gz" | grep -v '^$\|^\s*\#')
  set +e

  dialog --title "${DIALOG_TITLE}" \
         --clear \
         --msgbox "\n\nUpgrade done successfully!" 10 33

  dialog --title "${DIALOG_TITLE}" \
         --clear \
         --yesno "\n\nWould you like to configure LILO automatically?" 10 40

  case $? in
    0)
      :;;
    1)
      dialog --title "${DIALOG_TITLE}" \
             --clear \
             --msgbox "\nIMPORTANT: you need to change the configuration in /etc/lilo.conf and run LILO in order to use the new kernel!" 10 52
      exit;;
    255)
  esac

  # Create a basic entry for LILO
  IMG="image = /boot/vmlinuz-generic${SMP}-${KERN_NEW}${SMP}\n"
  INITRD="\x20\x20initrd = /boot/initrd-${KERN_NEW}${SMP}.gz\n"
  ROOT="\x20\x20root = $(findmnt --noheadings --output SOURCE /)\n"
  LABEL="\x20\x20label = ${KERN_NEW}${SMP}\n"
  FS_MOUNT="\x20\x20read-only"
  APPEND=""

  # Obtain the beginning and the end (line numbers) of the entry at the top in /etc/lilo.conf
  LILO_ENTRY_START=$(grep -n "image" /etc/lilo.conf | cut -d : -f 1 | head -n 1)
  LILO_ENTRY_STOP=$(grep -n "image" /etc/lilo.conf | cut -d : -f 1 | head -n 2 | tail -n 1) && \
  LILO_ENTRY_STOP=$((LILO_ENTRY_STOP-1))

  # Enter the parameters to append to the LILO entry
  exec 3>&1
  PARAMS=$(dialog \
    --title "${DIALOG_TITLE}" \
    --clear \
    --cancel-label "Exit" \
    --inputbox "\nEnter parameters to append (if any) as space-separated key=value pairs (e.g. key1=value1 key2=value2):\n\n[Leave the field empty and press OK to skip]" \
    12 60  \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-

  case $exit_status in
    0)
      # Check if PARAMS is not empty
      if [ -n "$PARAMS" ]; then
        PARAMS=$(echo $PARAMS | sed 's/ *$//')					# Remove extra spaces from PARAMS
        APPEND="\n\x20\x20append = \"${PARAMS}\""
      fi
      ;;
    1)
      dialog --title "${DIALOG_TITLE}" \
             --clear \
             --msgbox "\nIMPORTANT: you need to change the configuration in /etc/lilo.conf and run LILO in order to use the new kernel!" 10 52
      exit;;
    255)
  esac

  # Append parameters to the entry (if any)
  LILO_ENTRY="${IMG}${INITRD}${ROOT}${LABEL}${FS_MOUNT}${APPEND}"

  # Select the position of the entry in /etc/lilo.conf
  exec 3>&1
  selection=$(dialog \
    --title "${DIALOG_TITLE}" \
    --clear \
    --cancel-label "Exit" \
    --menu "\nPlease select an option for lilo.conf:" \
    10 43 2 \
    "1" "Add a new entry at the top" \
    "2" "Overwrite the current entry" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-

  case $exit_status in
    0)
      :;;
    1)
      dialog --title "${DIALOG_TITLE}" \
             --clear \
             --msgbox "\nIMPORTANT: you need to change the configuration in /etc/lilo.conf and run LILO in order to use the new kernel!" 10 52
      exit;;
    255)
      ;;
  esac

  # Create a backup of lilo.conf
  now="$(date +'%d-%m-%Y_%H-%M-%S')"
  cp /etc/lilo.conf /etc/lilo.conf.backup_${now}

  case $selection in
    1)
      # Insert the content of LILO_ENTRY in /etc/lilo.conf as top entry
      sed -i "/# Linux bootable partition config begins/a $(echo $LILO_ENTRY)" /etc/lilo.conf
      ;;
    2)
      # Remove the entry at the top in /etc/lilo.conf
      sed -i -e "${LILO_ENTRY_START},${LILO_ENTRY_STOP}d" /etc/lilo.conf
      # Write the new one, always as top entry
      sed -i "/# Linux bootable partition config begins/a $(echo $LILO_ENTRY)" /etc/lilo.conf
      ;;
  esac

  # Test LILO configuration
  dialog --backtitle "${DIALOG_TITLE}" \
         --infobox "\n\nTesting LILO configuration..." 7 40
  sleep 2
  set -e
  lilo -t

  # Overwrite the boot sector
  dialog --backtitle "${DIALOG_TITLE}" \
         --infobox "\n\nUpdating LILO configuration..." 7 40
  sleep 2
  lilo -v
  set +e

  dialog --title "${DIALOG_TITLE}" \
         --clear \
         --msgbox "\n\nConfiguration completed successfully! \n\nReboot and enjoy your new kernel." 10 45

  # Cleanup
  #rm -rf $TMP
else
  dialog --title "${DIALOG_TITLE}" \
         --clear \
         --msgbox "\n\nNo updates available." 10 30
fi
