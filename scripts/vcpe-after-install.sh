#!/bin/bash
#
# 2016 (c)
# Dmitrii Mostovshchikov <dmadm2008@gmail.com>
# The script is a trigger that to be placed under <cobbler_data>/triggers/install/post/ directory
# It uncheck the netboot flags once a server is being installed
#
 
logfile=/var/log/cobbler/install_post.log
 
log() {
    echo `date +"%Y-%m-%d %H:%M:%S"` $* | tee -a $logfile
}
 
if [ "$1" != "system" -o -z "$2" ]; then
    log "Not provided suitable arguments: $*. Exit."
    exit 0
fi
 
log "Starting to uncheck NETBOOT_ENABLED flag"
cobbler system edit --name "$2" --netboot-enabled=NO
 
if [ $? -eq 0 ]; then
    log "Netboot flag is off for system $2"
else
    log "Unexpected error caused during unchecking the netboot flag on system $2"
fi
 
exit 0
