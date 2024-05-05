#!/bin/sh

echo "This script will create a MachineConfig manifest to install
zfs-autobuild on a Ignition-provisioned system such as an
OpenShift or OKD node - this should be run from a system that
has [make] and [butane] installed."

if [ ! "$(which butane)" ] > /dev/null 2>&1; then
    echo "[butane] not found, please install before running this script."
    exit
fi

if [ ! "$(which make)" ] > /dev/null 2>&1; then
    echo "[make] not found, please install before running this script."
    exit
fi

echo "Creating a FAKEROOT..."
FAKEROOT=$(mktemp -d)

echo "Installing zfs-autobuild into the FAKEROOT..."
make install CONFDIR="${FAKEROOT}/etc"

echo "Copying the FAKEROOT out to ./zfs-autobuild-tree..."
cp -Lpr "${FAKEROOT}" ./zfs-autobuild-tree

echo "Creating 99-zfs-autobuild.yaml MachineConfig from 99-zfs-autobuild.bu template..."
butane 99-zfs-autobuild.bu --files-dir . -o 99-zfs-autobuild.yaml && \
echo "99-zfs-autobuild.yaml should now be available to apply."

echo "Cleaning up ./zfs-autobuild-tree..."
rm -r ./zfs-autobuild-tree > /dev/null 2>&1


