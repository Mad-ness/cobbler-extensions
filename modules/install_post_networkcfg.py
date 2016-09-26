# (c) 2016
# Dmitrii Mostovschikov <dmadm2008@gmail.com>
#
# License: GPLv2+

# The module prints a shell scripts that suitable
# to run it on a system side
# A shell script updates network configuration
# in regarding to details in Cobbler
# I decided to realize this function via module mechanism
# because of Cheetah web site is not available for few days
# so I don't have changes to learn its syntax
# to realize this via snippets

import distutils.sysconfig
import sys
import os
import traceback
from jinja2 import Template

output_script_name = '/var/lib/cobbler/scripts/networkcfg_'

plib = distutils.sysconfig.get_python_lib()
mod_path="%s/cobbler" % plib
sys.path.insert(0, mod_path)

from utils import _
import sys
from cobbler.cexceptions import CX
import utils


script_template = """
{% for iface in interfaces.keys() %}
# Created upon installation by Cobbler
cat << INTES > /etc/network/interfaces
auto lo
iface lo inet loopback

source-directory /etc/network/interfaces.d
INTES

cat << NET_{{ iface }} > /etc/network/interfaces.d/{{ iface }}
# Created upon installation
auto {{ iface }}
iface {{ iface }} inet static
	address {{ interfaces[iface].address }}
	netmask {{ interfaces[iface].netmask }}
        {% if 'hwaddress' in interfaces[iface] %}hwaddress {{ interfaces[iface].hwaddress }}{% endif %}
NET_{{ iface }}
{% endfor %}
"""


def register():
   # this pure python trigger acts as if it were a legacy shell-trigger, but is much faster.
   # the return of this method indicates the trigger type
   return "/var/lib/cobbler/triggers/install/pre/*"


def get_network_data(api, system, logger):
    result = {}

    for iface in system.to_datastruct()['interfaces']:
	idata = system.to_datastruct()['interfaces'][iface]
	if idata['interface_type'] == '' and idata['ip_address'] != '' and idata['netmask'] != '':
	    result[iface] = {
		'address': idata['ip_address'],
		'netmask': idata['netmask'],
	    }
	    if idata['mac_address'] != '': result[iface]['hwaddress'] = idata['mac_address']
	    if idata['if_gateway'] != '': result[iface]['gateway'] = idata['if_gateway']


    return result


def run(api, args, logger):

    objtype = args[0] # "target" or "profile"
    name    = args[1] # name of target or profile
    boot_ip = args[2] # ip or "?"

    logger.info("Look up an object type %s with name %s" % (objtype, name))
    if objtype != "system": return 0

    system = api.find_system(name)

    if system != None: 
	pass
    else:
	logger.error("System not found")

    interfaces = get_network_data(api, system, logger)

    # Generate a shell script
    templ = Template(script_template)
    shell_body = templ.render(interfaces=interfaces)

    try:
	# make a personal shell script for each system name
	shell_name = output_script_name + name
        with open(shell_name, 'w') as fd:
	    fd.write(shell_body)
        logger.info("Network configuration (ubuntu like) script has been installed for further using")
    except:
	e = sys.exc_info()[0]
	logger.error("Catch an error during saving a shell script: %s" % e)
	logger.error("Couldn't write a shell script into it persist location %s" % shell_name)

    
    return 0

