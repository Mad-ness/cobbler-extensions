
SCRIPTS = $(wildcard *.sh)

install_scripts:
	install -d $(COBBLER_ROOT)/scripts -m 0755
	for scr in $(SCRIPTS); do \
		install $$scr $(COBBLER_ROOT)/scripts -m 0644 ; \
	done

clean:
	for scr in $(SCRIPTS); do \
		unlink $(COBBLER_ROOT)/scripts/$$scr ;\
	done

