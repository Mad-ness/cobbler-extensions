#template=jinja2

# Created upon installation by Cobbler
cat << INTES > /etc/network/interfaces
auto lo
iface lo inet loopback

source-directory /etc/network/interfaces.d
INTES

# This is a trick, I don't know why but the installer rewrites this config and I cannot catch the moment
chattr +i /etc/network/interfaces

{% for iface in interfaces.keys() %}
{% if interfaces[iface].ip_address|default('') != '' and interfaces[iface].netmask|default('') != '' %}
{% set dot_split = iface.split('.') %}
cat << NET_DEF > /etc/network/interfaces.d/{{ dot_split }}
# Created upon installation
auto {{ iface }}
iface {{ iface }} inet static
	address {{ interfaces[iface].ip_address }}
	netmask {{ interfaces[iface].netmask }}
{% if interfaces[iface].if_gateway|default('') != '' %}
        gateway {{ interfaces[iface].if_gateway }}
{% endif %}
{% if interfaces[iface].mac_address|default('') != '' %}
        hwaddress {{ interfaces[iface].mac_address }}
{% endif %}
{% if dot_split|len == 2 %}
        vlan-raw-device {{ dot_split[0] }}
{% endif %}
NET_DEF
{% endif %}
{% endfor %}


# Rewrite rc.local script. This will unset the immutable flag on /etc/network/interfaces once OS firstly booted
cat << "STARTUP" > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

chattr -i /etc/network/interfaces                # delafterfirstboot
sed -i -e '/# delafterfirstboot/d' /etc/rc.local

exit 0
STARTUP
chmod +x /etc/rc.local
