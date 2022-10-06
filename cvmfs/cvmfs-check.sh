#!/bin/bash

# Check if /cvmfs is available using its test tool
# Remounts the filesystem in case of failure

cvmfs_probe=$(cvmfs_config probe)
ok_status="OK"
fail_status="Failed"

if [[ $cvmfs_probe == *"$ok_status"* ]];
then
    echo "/cvmfs is currently mounted successfully. Therefore, it is not required to remount it again."
elif [[ $cvmfs_probe == *"$fail_status"* ]];
then
    echo "/cvmfs health test failed. Remounting the filesystem."
    # Hardcode the path to the remounting script to enfoce both of these scripts are stored in /root/os
    bash /root/os/cvmfs/cvmfs-mount.sh
else
    echo "Error executing cvmfs_config tool. Please check this program is available inside the VM"    
fi