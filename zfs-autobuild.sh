#!/bin/sh

# Source some information about the container OS:
. /etc/os-release

# Create repo to download build dependencies:
cd /etc/yum.repos.d || exit
curl -L -O "https://src.fedoraproject.org/rpms/fedora-repos/raw/f${VERSION_ID}/f/fedora-updates-archive.repo" && \
        sed -i 's/enabled=AUTO_VALUE/enabled=true/' fedora-updates-archive.repo

# Install build dependencies:
dnf update -y && \
        dnf install -y jq dkms gcc make autoconf automake libtool rpm-build libtirpc-devel libblkid-devel \
        libuuid-devel libudev-devel openssl-devel zlib-devel libaio-devel libattr-devel elfutils-libelf-devel \
        "kernel-${ZFSAB_KERNEL_VERSION}" "kernel-modules-${ZFSAB_KERNEL_VERSION}" "kernel-devel-${ZFSAB_KERNEL_VERSION}" \
        python3 python3-devel python3-setuptools python3-cffi libffi-devel git ncompress libcurl-devel rsync dnf-plugins-core

# Check for availability of kernel source for version we're installing for:
if [ ! -d "/usr/src/kernels/${ZFSAB_KERNEL_VERSION}/" ]; then
  echo "ZFS Autobuild: Unable to find the kernel source directory at: /usr/src/kernels/${ZFSAB_KERNEL_VERSION}/"
  echo "ZFS Autobuild: This can happen if internet access is not currently available - unable to continue, exiting."
  exit
fi

# If it doesn't exist in the /src folder, download the specified version of ZFS:
if [ ! -f "/src/zfs-${ZFSAB_ZFS_VERSION}.tar.gz" ]; then
  cd /src || exit
  curl -L -O "https://github.com/openzfs/zfs/releases/download/zfs-${ZFSAB_ZFS_VERSION}/zfs-${ZFSAB_ZFS_VERSION}.tar.gz"
fi

# Clean up any prior /zfs folder that exists:
if [ -d /zfs/ ]; then
  rm -rf /zfs
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
rm -f /zfs/*devel*.rpm
rm -f /zfs/zfs-test*.rpm
rm -f /zfs/*debug*.rpm

# Make a folder for the version being created:
mkdir -p "/rpms/${ZFSAB_KERNEL_VERSION}-${ZFSAB_ZFS_VERSION}"

# Copy the built RPMs to the externally-accessible volume at /rpms:
rsync /zfs/*."$(rpm -qa kernel --queryformat '%{ARCH}')".rpm \
        /zfs/zfs-dracut-"${ZFSAB_ZFS_VERSION}"*.rpm \
        "/rpms/${ZFSAB_KERNEL_VERSION}-${ZFSAB_ZFS_VERSION}/"

# Download required dependencies to the same folder in case needed:
dnf download lm_sensors-libs pcp-conf pcp-libs sysstat --destdir "/rpms/${ZFSAB_KERNEL_VERSION}-${ZFSAB_ZFS_VERSION}/" --arch "$(rpm -qa kernel --queryformat '%{ARCH}')"