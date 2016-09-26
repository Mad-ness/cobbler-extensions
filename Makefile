COBBLER_ROOT=/var/lib/cobbler


export COBBLER_ROOT

install: install_scripts install_triggers install_kickstarts install_modules install_snippets

install_scripts:
	cd scripts scripts && make install_scripts

install_triggers:
	cd triggers && make install_triggers

install_kickstarts:
	cd kickstarts && make install

install_modules:
	cd modules && make install_modules

install_snippets:
	cd snippets && make install_snippets

clean: scripts_clean modules_clean snippets_clean

scripts_clean:
	cd scripts && make clean

modules_clean:
	cd modules && make clean

snippets_clean:
	cd snippets && make clean
