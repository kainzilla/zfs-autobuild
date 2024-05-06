# zfs-autobuild

A script designed to be used with [OKD](https://www.okd.io/)-provided Fedora CoreOS (an immutable OS) to build and install the ZFS kernel modules and supporting software

This script runs the ZFS build process for your current kernel version from sources inside a container. The script keeps older copies of ZFS source and ZFS RPMs in case needed.

## Installation

Installation:

```bash
# git clone https://github.com/kainzilla/zfs-autobuild.git /etc/zfs-autobuild
# /etc/zfs-autobuild/zfs-autobuild-module build
```

## Usage

The primary control script is located in /etc/zfs-autobuild/ to keep it out of your BASH auto-completions - the following commands are available:

```bash
/etc/zfs-autobuild/zfs-autobuild-module build          Build and install ZFS.
/etc/zfs-autobuild/zfs-autobuild-module build --force  Remove build pod, source, and RPMs before rebuilding.
/etc/zfs-autobuild/zfs-autobuild-module install        Install ZFS RPMs with rpm-ostree.
/etc/zfs-autobuild/zfs-autobuild-module uninstall      Uninstall ZFS RPMs with rpm-ostree.
/etc/zfs-autobuild/zfs-autobuild-module load           Load ZFS kernel module.
/etc/zfs-autobuild/zfs-autobuild-module unload         Unload ZFS kernel module.
/etc/zfs-autobuild/zfs-autobuild-module reload         Rebuild and reload ZFS module.
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
