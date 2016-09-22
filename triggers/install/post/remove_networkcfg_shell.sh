#!/bin/bash
#
# 2016 (c)
# Dmitrii Mostovshchikov <dmadm2008@gmail.com>
# The script is a trigger that to be placed under <cobbler_data>/triggers/install/post/ directory
# It removes a temprorary created shell script for configuring network interfaces
#

logfile=/var/log/cobbler/install_post.log

log() {
    echo `date +"%Y-%m-%d %H:%M:%S"` $* | tee -a $logfile
}

if [ "$1" != "system" -o -z "$2" ]; then
    log "Not provided suitable arguments: $*. Exit."
    exit 0
fi

log "Removing a shell script that've been using for configuring network on $2"
unlink /var/lib/cobbler/scripts/networkcfg_$2

exit 0

