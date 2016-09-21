COBBLER_ROOT=/tmp


export COBBLER_ROOT

install: install_scripts install_triggers install_kickstarts

install_scripts:
	cd scripts scripts && make install_scripts

install_triggers:
	cd triggers && make install_triggers

install_kickstarts:
	cd kickstarts && make install


