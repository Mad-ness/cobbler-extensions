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
import smtplib
import sys
import cobbler.templar as templar
from cobbler.cexceptions import CX
import utils

def register():
   # this pure python trigger acts as if it were a legacy shell-trigger, but is much faster.
   # the return of this method indicates the trigger type
   return "/var/lib/cobbler/triggers/install/post/*"

def run(api, args, logger):
    # FIXME: make everything use the logger

    settings = api.settings()

    # go no further if this feature is turned off
#    if not str(settings.build_reporting_enabled).lower() in [ "1", "yes", "y", "true"]:
#        return 0

    objtype = args[0] # "target" or "profile"
    name    = args[1] # name of target or profile
    boot_ip = args[2] # ip or "?"

    if objtype != "system": return 0
    target = api.find_system(name)[0]
   
    target[0].netboot_enabled = False 
    api.add_system(target[0])

    objtype = args[0] # "system" or "profile"
    name    = args[1] # name of system or profile
    ip      = args[2] # ip or "?"

    fd = open("/var/log/cobbler/install.log","a+")
    fd.write("%s\t%s\t%s\tstop\t%s\n" % (objtype,name,ip,time.time()))
    fd.close()
    
    return 0



