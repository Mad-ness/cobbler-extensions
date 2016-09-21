#!/bin/bash


add_ssh_pub_key() {
    user=deadman
    su - $user <<THIS_DEATH
        install -d ~/.ssh -m 0700
        echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDW7cG4fczHsXz5iqlgDSY/2D1ENpn8e7WVEU8IN5+i81LqnZ9L3QL+LuDLR+vdWvaRP09me++U6yzALoa0jN6nxPHIkjmMmA5kYdsWCVEMCEd3Q07/xIG0TlYHir4ggv3p7zP6K6PERqRFJ6IvzJRx4hWOqky1IgbQPOnzFs4BheYARDGY3dsepBaCtKQkIT1mlW1VEkKsfb4ARUMaCgv9IPosYsZ+0B8Jh9AQovtBEDoDFC5zXIcFznqbdL4w7iZ/5pQ025viyVnaeoRemTGBOP99+Z7Kh0b+LUt6f03GpikBkblJJM8iEC2sEV3rSrszMk4Ot5dtWhygoS4trtft' > ~/.ssh/authorized_keys
        chmod 0600 ~/.ssh/authorized_keys
THIS_DEATH
}


allow_deadman_sudo() {
    echo '#includedir /etc/sudoers.d' >> /etc/sudoers
    echo 'deadman ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers.d/deadman
}

# This allows to edit files in place
set_option() {
  s_file="$1"
  key="$2"
  value="$3"
  separator="$4"

  grep -qE "^\s*${key}\s*${separator}" $s_file
  if [ $? -eq 0 ]; then
      sed -i -e "s/^\s*${key}\s*${separator}.*$/${key}${separator}${value}/g" $s_file
  else
      echo "${key}${separator}${value}" >> $s_file
  fi
}

update_sshd() {
    set_option /etc/ssh/sshd_config "UseDNS"                 "no"    " "
    set_option /etc/ssh/sshd_config "PermitRootLogin"        "yes"    " "
    set_option /etc/ssh/sshd_config "PasswordAuthentication" "yes"    " "
}



add_ssh_pub_key
allow_deadman_sudo
update_sshd


exit 0

