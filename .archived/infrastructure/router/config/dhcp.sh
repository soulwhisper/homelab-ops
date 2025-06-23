#!/bin/vbash

# DHCP Server
set service dhcp-server hostfile-update
set service dhcp-server shared-network-name HOMELAB authoritative
set service dhcp-server shared-network-name HOMELAB option domain-name 'noirprime.com'
set service dhcp-server shared-network-name HOMELAB option domain-search 'noirprime.com'

## LAB
set service dhcp-server shared-network-name LAB subnet 10.10.0.0/24 subnet-id '1'
set service dhcp-server shared-network-name LAB subnet 10.10.0.0/24 option default-router '10.10.0.1'
set service dhcp-server shared-network-name LAB subnet 10.10.0.0/24 option name-server '10.10.0.1'
set service dhcp-server shared-network-name LAB subnet 10.10.0.0/24 range 0 start '10.10.0.101'
set service dhcp-server shared-network-name LAB subnet 10.10.0.0/24 range 0 stop '10.10.0.250'
