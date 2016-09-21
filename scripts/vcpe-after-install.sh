#!/bin/bash


function delete_dummy_volume() {
    lvs -o lv_name,vg_name --separator=\; | grep -qE 'dummy;rootvg'
    if [ $? -eq 0 ]; then
        umount /var/dummy 
        if [ $? -eq 0 ]; then
            sed -i -e '/\/var\/dummy/d' /etc/fstab
            lvremove --force rootvg/dummy
        fi
    fi 
}

function add_ssh_pub_key() {
    user=deadman
    su - $user <<THIS_DEATH
	install -d \$HOME/.ssh -m 0700
	echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDW7cG4fczHsXz5iqlgDSY/2D1ENpn8e7WVEU8IN5+i81LqnZ9L3QL+LuDLR+vdWvaRP09me++U6yzALoa0jN6nxPHIkjmMmA5kYdsWCVEMCEd3Q07/xIG0TlYHir4ggv3p7zP6K6PERqRFJ6IvzJRx4hWOqky1IgbQPOnzFs4BheYARDGY3dsepBaCtKQkIT1mlW1VEkKsfb4ARUMaCgv9IPosYsZ+0B8Jh9AQovtBEDoDFC5zXIcFznqbdL4w7iZ/5pQ025viyVnaeoRemTGBOP99+Z7Kh0b+LUt6f03GpikBkblJJM8iEC2sEV3rSrszMk4Ot5dtWhygoS4trtft' >> \$HOME/.ssh/authorized_keys
	chmod 0600 \$HOME/.ssh/authorized_keys
THIS_DEATH
}



add_ssh_pub_key
