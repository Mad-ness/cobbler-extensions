= Notes
There are a few findings I observed when have been trying to solve my issues.


== Selection of a template engine

It is possible to select either Cheetah or Jinja2 of template engines. For this there is an option defalt_template_engine in /etc/cobbler/settings (don't forget to restart cobblerd after the modification) that may be adjusted as required and used by default. Besides this option each of templated file may start from line

	#template=<engine_name>	[put one of these cheetah, jinja2]
	(no whitespaces allowed here)

This allows to set to a required renderer. Because of Cheetah website is almost dead (a few days not responding) it is good to set only converted templates in Jinja2 and to not break other templates. Probably you need to ensure that python can import jinja2 module.

=== <cobbler_data>/scripts
Files in these directories should use general cheetah syntax, for instance

	bash# cat scripts/preseed_late_default 
	# Start preseed_late_default
	# This script runs in the chroot /target by default
	# $SNIPPET('post_install_network_config_deb')
	$SNIPPET('late_apt_repo_config')
	$SNIPPET('post_run_deb')
	$SNIPPET('download_config_files')
	$SNIPPET('kickstart_done')
	# End preseed_late_default

But included snippets in <cobbler_data>/snippets directory already can go in both Cheetah and Jinja2 languages.

== <cobbler_data>/modules
- Any modifications performed in .py modules must issue the restarting of cobblerd service as they read only once during starting the service
