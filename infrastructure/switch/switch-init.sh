#!/bin/bash
# This script configures H3C S6520-24S-SI as core switch for a homelab environment
# It sets up VLAN, LACP, BGP, OSPF, DHCP Relay, Multicast, and other necessary configurations
# If pasted into the switch console, make sure to paste by phases to avoid errors

# : System basics
system-view
router-id 10.0.0.1

dhcp enable
multicast routing

# : Vlan configuration
vlan 100
vlan 200
vlan 210

interface vlan-interface 1
 description vlan-mgmt
 ip address 10.0.0.1 24
 jumboframe enable
 dhcp select relay
 dhcp relay server-address 10.0.0.254

interface vlan-interface 100
 description vlan-lab
 ip address 10.10.0.1 24
 jumboframe enable
 dhcp select relay
 dhcp relay server-address 10.10.0.254
 igmp enable

interface vlan-interface 200
 description vlan-wifi
 ip address 10.20.0.1 24
 jumboframe enable
 dhcp select relay
 dhcp relay server-address 10.20.0.254

interface vlan-interface 210
 description vlan-iot
 ip address 10.20.10.1 24
 jumboframe enable
 dhcp select relay
 dhcp relay server-address 10.20.10.254
 pim dm

# : LACP configuration
interface bridge-aggregation 1
 description k8s-node-01
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 lacp edge-port

interface bridge-aggregation 2
 description k8s-node-02
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 lacp edge-port

interface bridge-aggregation 3
 description k8s-node-03
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 lacp edge-port

interface bridge-aggregation 100
 description nas
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 lacp edge-port

interface bridge-aggregation 200
 description router
 link-aggregation mode dynamic
 port link-type trunk
 port trunk permit vlan 1 100 200 210
 jumboframe enable
 lacp edge-port

# : Interface configuration
# skipped

# : BGP configuration
 bgp 65510
  group k8s
  peer k8s bfd
  peer k8s connect-interface vlan-interface 100
  peer k8s next-hop-local
  peer 10.10.0.101 group k8s
  peer 10.10.0.102 group k8s
  peer 10.10.0.103 group k8s
  address-family ipv4
   peer k8s enable
   import-route ospf 1

# : OSPF configuration
ospf 1
 import-route bgp
 area 0
  network 10.0.0.0 0.0.0.255
  network 10.10.0.0 0.0.0.255
  network 10.20.0.0 0.0.0.255
  network 10.20.10.0 0.0.0.255

# : Others
display current-configuration diff
save safely main
