UPDATE_CMD=update_kickstart_profiles.sh
INSTALL_DIR=/var/lib/cobbler/kickstarts
INSTALL_DIR=/tmp
INSTALL_CMD=


build:
	/bin/sh $(UPDATE_CMD)

install: build	
	cp auto-* $(INSTALL_DIR)

clean:
	rm -f auto-*
