
SNIPPETS = $(wildcard *.sn)

install_snippets:
	install -d $(COBBLER_ROOT)/snippets -m 0755
	for scr in $(SNIPPETS); do \
		install $$scr $(COBBLER_ROOT)/snippets -m 0644 ; \
	done

clean:
	for scr in $(SNIPPETS); do \
		unlink $(COBBLER_ROOT)/snippets/$$scr ;\
	done

