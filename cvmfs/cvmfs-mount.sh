#!/bin/bash

# This script remounts manually the cvmfs filesystem in the machine
# This script and its implementation in the virtual machine does not override any previous configuration
# /cvmfs is configured by default to auto remount the filesystem using linux kernel tool: autofs
# If you want to see the autofs config for cvmfs please see /etc/auto.master
# Why is the purpose of this? Remount the cvmfs filesystem when there is a Transport connection error (FUSE).
# The filesystem remains mounted but it is not accessible, autofs does not check this case.

echo "Unmounting: /cvmfs/cvmfs-config.cern.ch"
umount /cvmfs/cvmfs-config.cern.ch
echo "Unmounting: /cvmfs/cms.cern.ch"
umount /cvmfs/cms.cern.ch

echo "Starting remounting both filesystems"

echo "Mounting: /cvmfs/cvmfs-config.cern.ch"
/usr/bin/cvmfs2 -o rw,fsname=cvmfs2,allow_other,grab_mountpoint,uid=994,gid=991 cvmfs-config.cern.ch /cvmfs/cvmfs-config.cern.ch
echo "Mounting: /cvmfs/cms.cern.ch"
/usr/bin/cvmfs2 -o rw,fsname=cvmfs2,allow_other,grab_mountpoint,uid=994,gid=991 cms.cern.ch /cvmfs/cms.cern.ch
