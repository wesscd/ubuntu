#!/bin/bash

# Check if OS is Ubuntu


check_permission() {
    if [ ! -x "$0" ]; then
        echo "Script does not have execution permission. Exiting..."
        exit 1
    fi
}
check_os() {
    if [ "$(lsb_release -is)" != "Ubuntu" ]; then
      echo "This script is designed for Ubuntu systems. Exiting."
      exit 1
    fi
}

configure_date_time() {
    timedatectl set-timezone America/Sao_Paulo
    apt-get install -y ntp ntpdate
    service ntp stop
    ntpdate a.st1.ntp.br
    service ntp start
}

# Update the system
update_upgrade() {
    sudo apt-get update && sudo apt-get upgrade -y
    apt-get -y autoremove
    apt-get -y autoclean
    apt-get -y clean 
}

# Install neofetch
install_neofetch(){
    sudo apt-get install neofetch -y
}

# Configure neofetch as motd
neofetch_to_motd(){
    sudo bash -c "echo 'neofetch' >> /etc/motd"
}

# Main function
main() {
    check_permission
    check_os
    configure_date_time
    update_upgrade
    install_neofetch
    neofetch_to_motd
}

# Run main function
main
