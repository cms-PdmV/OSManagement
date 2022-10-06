#!/bin/bash

# Install this tool inside the VM.
# ----------------------------------------------------

echo "CVMFS File System Checker"
echo "To work properly, this script requires root privileges to copy the program files inside /root"
echo "and create a service in systemd"
echo "Please enter root password"

# Ask for root permissions
[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}

# Folder to store this program
FOLDER=/root/os/cvmfs
SYSTEMD_SERVICE_FOLDER=/etc/systemd/system

# Create folder
mkdir -p "$FOLDER/"

# Copy scripts to the destination folder
cp ./cvmfs-check.sh "$FOLDER/"
cp ./cvmfs-mount.sh "$FOLDER/"

# Copy service's files to systemd folder
cp ./cvmfs-check.service "$SYSTEMD_SERVICE_FOLDER/"
cp ./cvmfs-check.timer "$SYSTEMD_SERVICE_FOLDER/"

# Enable the service and its timer to be executed by systemd
systemctl enable --now cvmfs-check.service
systemctl enable --now cvmfs-check.timer

# Reload services cache
systemctl daemon-reload


