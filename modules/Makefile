
MODULES = $(wildcard install*.py)
MODULES_DIR=/usr/lib/python2.7/site-packages/cobbler/modules

install_modules:
#	install -d $(MODULES_DIR) -m 0644
	for scr in $(MODULES); do \
		install $$scr $(MODULES_DIR) -m 0644 ; \
	done

clean:
	for scr in $(MODULES); do \
		unlink $(MODULES_DIR)/$$scr ;\
	done

