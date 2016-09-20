#!/usr/bin/env

import cobbler.api as capi
from install_post_uncheck_netboot import *

handle = capi.BootAPI()
#def run(api, args, logger):

class DummyLogger:
	def info(self, msg): print("[ DDD ]: %s" % msg)
	def err(self, msg): print("[ DDD ]: %s" % msg)

logger = DummyLogger()

run(handle, ['system', 'vCPE-storage-2', '192.168.1.31'], logger)



