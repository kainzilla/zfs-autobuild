# zfs-autobuild

A script designed to be used with Fedora CoreOS (an immutable OS) to check for and build the ZFS kernel modules and supporting software during boot time _if_ the current kernel version and ZFS version might have changed (such as OS updates). This is based on the [Atomic WireGuard](https://github.com/jdoss/atomic-wireguard/) script with hints on what works from the CoreOS [layering-examples Containerfile](https://github.com/coreos/layering-examples/blob/main/build-zfs-module/Containerfile). This is a sort of workaround for the lack of DKMS support on immutable OSes combined with the fact that ZFS won't be included in the Linux kernel anytime soon.

This script runs the ZFS build process for your current kernel version from sources, inside of a container to keep your system clean, and keeps older copies of ZFS source and ZFS RPMs for a configurable duration of time. The automatic cleanup defaults to removing versions that haven't been used in more than 180 days since last-use of that specific kernel+version combo.

Caveats:
* When the system needs to build ZFS to match your current desired version and kernel, it will delay boot-up while it builds.
* Although this script technically requires internet access, it tries to keep recently-used copies of the ZFS source to recompile for new kernels in case you've lost internet access at an inopportune time.
* I can't imagine this script will work for Linux installs with ZFS for the root partition - I  personally use this for ZFS support on non-OS disks.

## Installation

Installation for a typical system with `make` available:

```bash
# git clone https://github.com/kainzilla/zfs-autobuild.git
# cd zfs-autobuild
# make install
```

Before you enable the systemd service, you can check the configuration file located at `/etc/zfs-autobuild/zfs-autobuild.conf` to confirm if the default settings are right for you. Then enable the systemd service:

```bash
# systemctl daemon-reload
# systemctl enable --now zfs-autobuild.service
```

Installation instructions for immutable systems are in progress, but the `ignition-creator.sh` script can create MachineConfig files when run on systems with `make` and `butane` installed.

## Usage

The primary control script is located in /etc/zfs-autobuild/ to keep it out of your BASH auto-completions - in case you need to manually trigger the script outside of the systemd service, the following commands are available:

```bash
/etc/zfs-autobuild/zfs-autobuild-module build       Build and install ZFS.
/etc/zfs-autobuild/zfs-autobuild-module load        Load ZFS kernel module.
/etc/zfs-autobuild/zfs-autobuild-module unload      Unload ZFS kernel module.
/etc/zfs-autobuild/zfs-autobuild-module reload      Rebuild and reload ZFS module.
```

## License

The MIT License

Copyright (c) 2019 Joe Doss
Copyright (c) 2024 kainzilla

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
