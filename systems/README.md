# Format of a system template

A template consists of a few global sections

- a system common information, such as hostname
- netboot configuration
- network interfaces configuration


## A system common information

Next options are possible:

These options should go at a top level.

    hostname: server1.example.com


## Netboot configuration

Netboot configuration is started by `netboot_configuration` at top level and all included options should be placed below it.

    netboot_configuration:
        kernel_options:     # options to be included in a boot menu
        - interface: em1    # example, this interface is used to discover dhcp
    kickstart_profile: /path/to/local/file.ks
                            # this file is provided for auto answers
    install_profile:        # name of a profile registered in Cobbler
    

## Network configuration

In this section are defined options of all network interfaces that should be configured.
This section starts from a keyword `network_configuration`.

    network_configurations:
                           # DNS servers
        dns_servers: [ 8.8.4.4, 8.8.8.8 ]    
        interfaces: {}     # Interfaces configurations

The `interfaces` option is complex. It contains a list of interfaces for configuring, a few kinds of configuring are supported: dhcp, static, vlan, bonding. Some of options in these are optional and some mandatory.

Mandatory options are:
    
    id: em1                         # Just a label for internal use
    name: em1                       # Name of an interface that will to be used or created
                                    # visible in OS for programs
    ipconfig: dhcp                  # possible values: dhcp, static, vlan, 
                                    # bonding, bonding_slave, bonding_master

The options `id` must be unique among all interfaces definitions.

Optional options depend on what type of configuring is selected, see below sections for these. But some options still maybe used everywhere, these are:

    hwaddress: 00:00:00:00:00:01    # MAC address of a device
    routes:                         # It adds the routes as it listed
    - dest: 192.168.2.0/24          # Destination, supported just ipaddrs and subnets
      via: 192.168.1.1              # (optional), it specifies where is a destination
                                    # should be looked for.
                                    # If this key via is not provided then
                                    # name of the device (name) is used
                                    # instead of via gateway
                                    # Option routes is supported for interfaces that hold ip addresses,
                                    # it isn't supported for bonding_slave, bonding_master and so on.


### Interface configuration: dhcp

This specified that an interface should be configured by a dhcp client.

Example:

    id: em1
    name: em1
    ipconfig: dhcp
    hwaddress: 00:00:00:00:00:01    # (optional)


### Interface configuration: static
    
This kind of configuration suggests the manual IP address assignment. Possible options find out in the example below.

    id: p3p1_static
    name: p3p1
    ipconfig: static
    address: 192.168.1.1
    netmask: 255.255.255.0
    hwaddress: 00:00:00:00:00:01    # (optional)
    routes: []                      # (optional)


### Interface configuration: bonding_slave

This value should be used then need to configure a bonding interface. This is used for defining a part of a bond.

Example:

    id: p3p1_bond0_slave
    name: p3p1
    ipconfig: bonding_slave
    hwaddress: 00:00:00:00:00:01    # (optional)    

    id: p3p2_bond0_master
    name: p3p2
    ipconfig: bonding_master
    hwaddress: 00:00:00:00:00:01    # (optional)    

    id: p3p3_bond0_slave
    name: p3p3
    ipconfig: bonding_slave
    hwaddress: 00:00:00:00:00:01    # (optional)    

Important note: Only one interface could have ipconfig = bonding_master.


### Interface configuration: bonding

This kind of configuring depends on bonding_master and/or bonding_slave predefined definitions.

Example:

    id: bond0
    name: bond0
    ipconfig: bonding
    bonding_devices: [ p3p1, p3p2, p3p3 ]
    address: 172.16.1.1
    netmask: 255.255.255.0
    routes:             # (optional)
          - dest: 192.168.0.0/16
          - dest: 10.19.0.0/8
            via: 192.168.34.192

### Interface configuration: vlan

This value allows to define vlan tagging.

Example:
    
    id: bond0.5
    name: bond.5
    ipconfig: vlan
    device: bond0
    address: 10.5.0.0
    netmask: 255.255.255.0
    routes: []                     # (optional)
            
    id: bond0.6
    name: bond.6
    ipconfig: vlan
    device: bond0
    address: 10.6.0.0
    netmask: 255.255.255.0
    

## A complete example

This is a comple example.

    hostname: server1.example.com
        netboot_enabled: false
        netboot_configuration:
                kernel_options:
                  - interface: em1
                kickstart_file: /path/to/kickstart/file
                install_profile: ubuntu-server-14.04.5-x64_86
        network_configuration:
                dns_servers: [ 8.8.4.4, 8.8.8.8 ]
                interfaces:
                - id: em1
                  name: em1
                  ipconfig: dhcp
                  hwaddress: '00:00:00:00:00:01'
                - id: p3p1_static
                  name: p3p1
                  ipconfig: static
                  address: 192.168.1.1
                  netmask: 255.255.255.0
                  hwaddress: '00:00:00:00:00:02'
                  routes: 
                  - dest: 192.168.2.0/24 
                    via 192.168.1.1
                  - dest: 192.168.3.0/24
                  - dest: 192.168.4.0/24
                - id: p3p1_bond0_slave
                  name: p3p1
                  ipconfig: bonding_slave
                - id: p3p2
                  name: p3p2
                  ipconfig: bonding_master      
                - id: p3p3
                  name: p3p3
                  ipconfig: bonding_slave
                - id: bond0
                  name: bond0
                  ipconfig: bonding
                  bonding_devices: [ p3p1, p3p2, p3p3 ]
                  address: 172.16.1.1
                  netmask: 255.255.255.0
                  routes:
                  - dest: 192.168.0.0/16
                  - dest: 10.19.0.0/8
                    via: 192.168.34.192
                - id: bond0.6
                  name: bond0.6
                  ipconfig: vlan
                  device: bond0
                  address: 10.0.0.1
                  netmask: 255.255.255.0 
                  routes: []


