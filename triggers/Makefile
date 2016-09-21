
FILES_INSTALL_PRE := $(shell ls install/pre)
FILES_INSTALL_POST := $(shell ls install/post)


install_triggers: install_pre install_post

install_pre:
	install -d $(COBBLER_ROOT)/triggers/install/pre -m 0755
	for scr in $(FILES_INSTALL_PRE); do \
		install install/pre/$$scr $(COBBLER_ROOT)/triggers/install/pre/$$scr -m 0755; \
	done

install_post:
	install -d $(COBBLER_ROOT)/triggers/install/post -m 0755
	for scr in $(FILES_INSTALL_POST); do \
		install install/post/$$scr $(COBBLER_ROOT)/triggers/install/post/$$scr -m 0755; \
	done

