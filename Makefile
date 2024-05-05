# Set the default location in case not being built to a FAKEROOT:
ifndef CONFDIR
CONFDIR=/etc
endif

# Make directories that might not exist:
$(info $(shell mkdir -p $(CONFDIR)/zfs-autobuild/))
$(info $(shell mkdir -p $(CONFDIR)/systemd/system/))

# Install the files:
install:
	install -v -m 755 zfs-autobuild-module $(CONFDIR)/zfs-autobuild/
	install -v -m 755 zfs-autobuild.sh $(CONFDIR)/zfs-autobuild/
	install -v -m 644 zfs-autobuild.service $(CONFDIR)/systemd/system/
	install -v -m 644 zfs-autobuild.conf $(CONFDIR)/zfs-autobuild/