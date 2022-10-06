#!/bin/bash

# Install this tool inside the VM.
# ----------------------------------------------------

echo "CVMFS File System Checker - Uninstaller"
echo "To work properly, this script requires root privileges"

# Ask for root permissions
[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}

# Folder to store this program
FOLDER=/root/os/cvmfs
SYSTEMD_SERVICE_FOLDER=/etc/systemd/system

# Disable the service and its timer
systemctl disable --now cvmfs-check.service
systemctl disable --now cvmfs-check.timer

# Reload services cache
systemctl daemon-reload

# Delete tool folder inside /root
rm -rf "$FOLDER/"

# Delete files inside systemd folder
rm -f "$SYSTEMD_SERVICE_FOLDER/cvmfs-check.service"
rm -f "$SYSTEMD_SERVICE_FOLDER/cvmfs-check.timer"

echo "Unstalling process successfully completed"



