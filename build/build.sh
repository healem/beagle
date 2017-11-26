#!/bin/bash
set -e

# Makes sure this is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

VERSION=0.1-sauri
HOME=/home/healem/projects/automation/beagle
TMPDIR=/tmp/os
IMGNAME=ubuntu-16.04.3-minimal-armhf-2017-10-10.tar.xz
IMAGE=${HOME}/${IMGNAME}
KERNEL=$(cat ${HOME}/bb-kernel/KERNEL/include/generated/utsrelease.h | tr -d '"' | cut -d" " -f3)

if [ "$KERNEL" == "" ]; then
    echo "Did not find kernel version"
    exit 1
fi

echo "Found kernel version: $KERNEL"

if [ -d "$TMPDIR" ]; then
    rm -rf "$TMPDIR"
fi
    
mkdir -p "$TMPDIR"

# Prep root fs
cp $IMAGE $TMPDIR
cd $TMPDIR
mkdir rootfs
tar xfvp ${HOME}/*-*-*-armhf-*/armhf-rootfs-*.tar -C ${TMPDIR}/rootfs
rm -f ${TMPDIR}/${IMGNAME}

# Copy kernel
cp -v ${HOME}/bb-kernel/deploy/${KERNEL}.zImage ${TMPDIR}/rootfs/boot/vmlinuz-${KERNEL}
mkdir -p ${TMPDIR}/rootfs/boot/dtbs/${KERNEL}/
tar xfv ${HOME}/bb-kernel/deploy/${KERNEL}-dtbs.tar.gz -C ${TMPDIR}/rootfs/boot/dtbs/${KERNEL}/
tar xfv ${HOME}/bb-kernel/deploy/${KERNEL}-modules.tar.gz -C ${TMPDIR}/rootfs/

# Add partition to fstab
sh -c "echo '/dev/mmcblk0p1  /  auto  errors=remount-ro  0  1' >> ${TMPDIR}/rootfs/etc/fstab"

# Copy files into image
cp -ar ${HOME}/beagle/build/files/* ${TMPDIR}/rootfs/

# Copy in firstboot scripts
mkdir -p ${TMPDIR}/rootfs/root
cp -ar ${HOME}/beagle/build/firstboot ${TMPDIR}/rootfs/root/

# Create tarball
cd ${TMPDIR}
tar -czvf beagle-${VERSION}.tar.gz --exclude=beagle-${VERSION}.tar.gz -C ${TMPDIR}/rootfs/ .