#!/bin/bash

syslist=systems.csv
kickstart_dir=/var/lib/cobbler/kickstarts

if [ ! -f $syslist ]; then
	echo "Systems list is not found!"
	exit 1
fi


add_system() {
    sysname="$1"
    hostname="$2"
    boot_iface="$3"
    kickstart_profile="$4"
    netboot="$5"
    status="$6"
    macaddr="$7"
    ipaddr="$8"
    netmask="$9"
    gateway="${10}"
    kern_opts="${11}"
  
#    echo -n "  >> Adding/editing system $name ... "

    action="add"

    cobbler system report --name "$name" &>/dev/null
    if [ $? -eq 0 ]; then
        action="edit"
    fi

    cat << SYSTEM
    - id: $sysname
      name: $sysname
      hostname: $hostname
      kernel_options: interface=$boot_iface
      kickstart_file: $kickstart_profile
      netboot_enabled: false
      profile_name: ubuntu-server-14.04.5-x86_64
      environment: $status
      networks:
      - id: $boot_if
        iface: $boot_if
        mac_address: "$macaddr"
        ip_ipaddress: $ipaddr
        netmask: $netmask
        gateway: 192.168.1.1

SYSTEM
    return  0
    cobbler system $action \
	--name=$sysname \
	--netboot-enabled="$netboot" \
        --status="$status" \
	--kickstart="$kickstart_dir/$kickstart_profile" \
	--hostname="$hostname" \
	--mac="$macaddr" \
	--ip-address="$ipaddr" \
	--interface-type=na \
	--static=YES \
	--subnet="$netmask" \
	--interface="$boot_iface" \
        --profile=ubuntu-server-14.04.5-x86_64 \
	--kopts="$kern_opts"

    if [ $? -eq 0 ]; then
	echo OK
    else
	echo FAIL
    fi
}


del_system() { 

	echo -n "  >> Removing system $name ..."
	cobbler system remove --name="$1"; 
	if [ $? -eq 0 ]; then
		echo REMOVED
	else
		echo FAIL
	fi

}

handle_system_file() {

    awk -F\| '$1 ~ /^\s*(present|absent)\s*$/ {print}' $syslist | while read system; do

	# Split incoming string into array separated by '|'
	IFS='|' read -r -a sysarr <<< "$system"

	state="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
        name="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
	hostname="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
        boot_if="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
        kickstart="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
        netboot="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
	profile="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
        status="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
	macaddr="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
        ipaddr="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
	netmask="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
	gateway="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")
	kern_opts="${sysarr[0]}"; sysarr=("${sysarr[@]:1}")



	case $state in
	    present)
		add_system \
			$name \
			$hostname \
			$boot_if \
			$kickstart \
			$netboot \
			$status \
			$macaddr \
			$ipaddr \
			$netmask \
			$gateway \
			$kern_opts
	    ;;
	    absent)
		del_system $name
	    ;;
	esac


    done
}


handle_system_file


