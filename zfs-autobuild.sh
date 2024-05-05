#!/bin/sh

# Create repo to download build dependencies:
cd /etc/yum.repos.d || exit
curl -L -O "https://src.fedoraproject.org/rpms/fedora-repos/raw/f${ZFSAB_BUILDER_VERSION}/f/fedora-updates-archive.repo" && \
        sed -i 's/enabled=AUTO_VALUE/enabled=true/' fedora-updates-archive.repo

# Install build dependencies:
dnf update -y && \
        dnf install -y jq dkms gcc make autoconf automake libtool rpm-build libtirpc-devel libblkid-devel \
        libuuid-devel libudev-devel openssl-devel zlib-devel libaio-devel libattr-devel elfutils-libelf-devel \
        "kernel-${ZFSAB_KERNEL_VERSION}" "kernel-modules-${ZFSAB_KERNEL_VERSION}" "kernel-devel-${ZFSAB_KERNEL_VERSION}" \
        python3 python3-devel python3-setuptools python3-cffi libffi-devel git ncompress libcurl-devel

# If it doesn't exist in the /src folder, download the specified version of ZFS:
if [ ! -f "/src/zfs-${ZFSAB_ZFS_VERSION}.tar.gz" ]; then
  cd /src || exit
  curl -L -O "https://github.com/openzfs/zfs/releases/download/zfs-${ZFSAB_ZFS_VERSION}/zfs-${ZFSAB_ZFS_VERSION}.tar.gz"
fi

# Extract the selected version:
cp "/src/zfs-${ZFSAB_ZFS_VERSION}.tar.gz" / && \
cd / && \
tar xzf "zfs-${ZFSAB_ZFS_VERSION}.tar.gz" && \
mv "zfs-${ZFSAB_ZFS_VERSION}" zfs

# Build ZFS:
cd /zfs/ || exit
./configure -with-linux="/usr/src/kernels/${ZFSAB_KERNEL_VERSION}/" -with-linux-obj="/usr/src/kernels/${ZFSAB_KERNEL_VERSION}/" && \
        make -j1 rpm-utils rpm-kmod

# Clean up unneeded RPMs:
rm /zfs/*devel*.rpm /zfs/zfs-test*.rpm

# Make a folder for the version being created:
mkdir "/rpms/${ZFSAB_KERNEL_VERSION}-${ZFSAB_ZFS_VERSION}"

# Copy the built RPMs to the externally-accessible volume at /rpms:
cp /zfs/*.rpm "/rpms/${ZFSAB_KERNEL_VERSION}-${ZFSAB_ZFS_VERSION}/"