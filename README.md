= README.md
= Notes
There are a few findings I observed when have been trying to solve my issues.


== Selection of a template engine

It is possible to select either Cheetah or Jinja2 of template engines. For this there is an option defalt_template_type in /etc/cobbler/settings (don't forget to restart cobblerd after the modification) that may be adjusted as required and used by default. Besides this option each of templated file may start from line

	#template=<engine_name>	[put one of these cheetah, jinja2] - see the update a little below
	(no whitespaces allowed here)


This allows to set to a required renderer. Because of Cheetah website is almost dead (a few days not responding) it is good to set only converted templates in Jinja2 and to not break other templates. Probably you need to ensure that python can import jinja2 module with no errors.

Update: It is not a good idea to set a global variable to jinja2. It breaks a lot of templates using for generating pxe configurations. So in case of you do the changing of an engine you have to take care about of all templates are even used by Cobbler to be rewritten for Jinja2 perspective, include files in /etc/cobbler/*.

=== <cobbler_data>/scripts

In general <cobbler_data> is /var/lib/cobbler path and is hardcoded.

Files in these directories may use general cheetah syntax, for instance:

	bash# cat scripts/preseed_late_default 
        #template=cheetah
	# Start preseed_late_default
	# This script runs in the chroot /target by default
	# $SNIPPET('post_install_network_config_deb')
	$SNIPPET('late_apt_repo_config')
	$SNIPPET('post_run_deb')
	$SNIPPET('download_config_files')
	$SNIPPET('kickstart_done')
	# End preseed_late_default

Also the files may use jinja2 syntax, for instance:

	#template=jinja2
	# Created upon installation by Cobbler
	cat << INTES > /etc/network/interfaces
	auto lo
	iface lo inet loopback
	
	source-directory /etc/network/interfaces.d
	INTES
	
	{% for iface in interfaces.keys() %}
	{% if interfaces[iface].ip_address|default('') != '' and interfaces[iface].netmask|default('') != '' %}
	cat << NET_{{ iface }} > /etc/network/interfaces.d/{{ iface }}
	# Created upon installation
	auto {{ iface }}
	iface {{ iface }} inet static
		address {{ interfaces[iface].ip_address }}
		netmask {{ interfaces[iface].netmask }}
	        {% if interfaces[iface].mac_address|default('') != '' %}hwaddress {{ interfaces[iface].mac_address }}{% endif %}
	NET_{{ iface }}
	{% endif %}
	{% endfor %}

Unfortunatly $SNIPPETS directive is not supported in case of Jinja2.

==== How to ensure that my scripts correctly parsed

As a rule the scripts are being used such way, during installation for instance:
	
	file: example.seed
	...
	d-i preseed/late_command string \
		wget -O- http://$http_server/cblr/svc/op/script/$what/$name/?script=here.on2 | chroot /target /bin/sh -s
	...

Variable $name is coming from Cobbler itself and variable $what is defined next way in a pressed file above than its calling:

	#if $getVar('system_name','') != ''
	#set $what = "system"
	#else
	#set $what = "profile"
	#end if

I have found this code in examples, <cobbler_data>/kickstarts, coming out of box.


==== Some facts:

- Files in the <cobbler_data>/scripts directory may be written in Cheetah and Jinja2 languages
- If scripts <cobbler_data>/scripts are written in Cheetah when snippets also should be written in Cheetah
- If scripts <cobbler_data>/scripts are written in Jinja2 then they cannot contain includings like $SNIPPETS. Here is just missing source code for processing separate files.
- You cannot mix includings in both languages jinja2 and cheetah
- Poor supporting of Jinja2 templating


== <cobbler_data>/modules
- Any modifications performed in .py modules must issue the restarting of cobblerd service as they read only once during starting the service
