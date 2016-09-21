#!/bin/bash

templates_dir="/etc/cobbler/build_templates"
templates_dir=.
kickstart_dir="/var/lib/cobbler/kickstarts"
kickstart_dir=.


if [ -n "$1" -a -d "$1" ]; then
    kickstart_dir="$1"
fi

make_vcpe_kickstart() {

    outfile="$1"; shift
    include_files="$*"
    t_prefix="auto-vcpe-"

    (
        cat $templates_dir/10_ub-vcpe.part
        for inc in $include_files; do
            cat $templates_dir/$inc
        done    
        cat $templates_dir/30_ub-vcpe.part
    ) > $kickstart_dir/${t_prefix}$outfile

}

# make_vcpe_kickstart controller-disklayout-1.seed controller-disklayout-1.inc
make_vcpe_kickstart compute-disklayout-1.seed compute-disklayout-1.inc
make_vcpe_kickstart storage-disklayout-1.seed storage-disklayout-1.inc
make_vcpe_kickstart network-disklayout-1.seed network-disklayout-1.inc

