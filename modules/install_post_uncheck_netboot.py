# (c) 2016
# Dmitrii Mostovschikov <dmadm2008@gmail.com>
#
# License: GPLv2+

# Post install trigger for cobbler to
# uncheck netboot_enable option
# after a server being installed
# contains target information.

import distutils.sysconfig
import sys
import os
import traceback

plib = distutils.sysconfig.get_python_lib()
mod_path="%s/cobbler" % plib
sys.path.insert(0, mod_path)

from utils import _
import sys
from cobbler.cexceptions import CX
import utils

def register():
   # this pure python trigger acts as if it were a legacy shell-trigger, but is much faster.
   # the return of this method indicates the trigger type
   return "/var/lib/cobbler/triggers/install/pre/*"

def run(api, args, logger):
    # FIXME: make everything use the logger

#    settings = api.settings()

    # go no further if this feature is turned off
#    if not str(settings.build_reporting_enabled).lower() in [ "1", "yes", "y", "true"]:
#        return 0

    objtype = args[0] # "target" or "profile"
    name    = args[1] # name of target or profile
    boot_ip = args[2] # ip or "?"

    logger.info("Look up an object type %s with name %s" % (objtype, name))
    if objtype != "system": return 0

    system = api.find_system(name)

    if system != None: 
	logger.info("System found")
    else:
	logger.error("System not found")
 
    # see disable_netboot function in remote.py of cobbler's source code 
    logger.info("Set netboot_enabled in off")
    system.set_netboot_enabled(False)
    api.add_system(system)
    logger.info("Update dhcp settings")
    api.sync_dhcp()
    
    return 0



