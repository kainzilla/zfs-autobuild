ifndef CONFDIR
CONFDIR=/etc
endif

install:
	install -v -m 755 zfs-autobuild-module $(CONFDIR)/zfs-autobuild/
	install -v -m 755 zfs-autobuild.sh $(CONFDIR)/zfs-autobuild/
	install -v -m 644 zfs-autobuild.service $(CONFDIR)/systemd/system/
	install -v -m 644 zfs-autobuild.conf $(CONFDIR)/zfs-autobuild/