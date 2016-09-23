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

