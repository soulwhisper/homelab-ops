#!/bin/bash
# This script configures H3C S6520-24S-SI as core switch for a homelab environment
# It sets up VLAN, LACP, BGP, OSPF, DHCP Relay, Multicast, and other necessary configurations
# If pasted into the switch console, make sure to paste by phases to avoid errors

# system
sysname core-switch
ntp-service enable
clock timezone Beijing add 08:00:00
clock protocol ntp
ntp-service unicast-server 10.0.0.254

password-recovery enable
link-aggregation global load-sharing mode source-ip destination-ip source-mac destination-mac source-port destination-port
ipv6 nd detection port-match-ignore

bfd session init-mode active

dhcp enable
dhcp snooping enable
ipv6 dhcp snooping enable

multicast routing

stp global enable
stp mode rstp
stp instance 0 root primary
stp bpdu-filter

# vlan
vlan 10
dhcp snooping binding record
ipv6 dhcp snooping binding record
ipv6 nd detection enable

vlan 100
dhcp snooping binding record
ipv6 dhcp snooping binding record
ipv6 nd detection enable

vlan 200
dhcp snooping binding record
ipv6 dhcp snooping binding record
ipv6 nd detection enable

vlan 210
dhcp snooping binding record
ipv6 dhcp snooping binding record
ipv6 nd detection enable

# eBGP with BFD & OSPF
bgp 65000
 router-id 10.0.0.1
 timer keepalive 60 hold 180
 group k8s external
  peer k8s bfd
  peer k8s as-number 65100
  peer k8s connect-interface vlan-interface 100
 peer 10.10.0.101 group k8s
 peer 10.10.0.102 group k8s
 peer 10.10.0.103 group k8s
 address-family ipv4
  peer k8s enable
  import-route ospf 1

ospf 1
 area 0
  network 10.0.0.0 0.0.0.255
  network 10.0.10.0 0.0.0.255
  network 10.10.0.0 0.0.0.255
  network 10.20.0.0 0.0.0.255
  network 10.20.10.0 0.0.0.255

ospfv3 1
 router-id 10.0.0.1
 import-route direct

# LACP to K8S
interface bridge-aggregation 1
 description k8s-node-01
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 lacp edge-port
 stp edged-port
 stp root-protection
 dhcp snooping rate-limit 64
 dhcp snooping check request-message
 dhcp snooping check mac-address
 ipv6 dhcp snooping rate-limit 64
 ipv6 dhcp snooping check request-message
 ipv6 nd raguard role host

interface bridge-aggregation 2
 description k8s-node-02
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 lacp edge-port
 stp edged-port
 stp root-protection
 dhcp snooping rate-limit 64
 dhcp snooping check request-message
 dhcp snooping check mac-address
 ipv6 dhcp snooping rate-limit 64
 ipv6 dhcp snooping check request-message
 ipv6 nd raguard role host

interface bridge-aggregation 3
 description k8s-node-03
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 lacp edge-port
 stp edged-port
 stp root-protection
 dhcp snooping rate-limit 64
 dhcp snooping check request-message
 dhcp snooping check mac-address
 ipv6 dhcp snooping rate-limit 64
 ipv6 dhcp snooping check request-message
 ipv6 nd raguard role host

interface ten-gigabitethernet 1/0/1
 port link-aggregation group 1

interface ten-gigabitethernet 1/0/2
 port link-aggregation group 1

interface ten-gigabitethernet 1/0/3
 port link-aggregation group 2

interface ten-gigabitethernet 1/0/4
 port link-aggregation group 2

interface ten-gigabitethernet 1/0/5
 port link-aggregation group 3

interface ten-gigabitethernet 1/0/6
 port link-aggregation group 3

# Port to NAS, or LACP 100
interface ten-gigabitethernet 1/0/13
 port link-type access
 port access vlan 100
 jumboframe enable
 stp edged-port
 stp root-protection
 dhcp snooping rate-limit 64
 dhcp snooping check request-message
 dhcp snooping check mac-address
 ipv6 dhcp snooping rate-limit 64
 ipv6 dhcp snooping check request-message
 ipv6 nd raguard role host

# to management-switch, LACP 800
interface ten-gigabitethernet 1/0/17
 description management-switch
 port link-type access
 port access vlan 1
 jumboframe enable
 stp root-protection
 dhcp snooping rate-limit 64
 dhcp snooping check request-message
 dhcp snooping check mac-address
 ipv6 dhcp snooping rate-limit 64
 ipv6 dhcp snooping check request-message
 ipv6 nd raguard role host

interface ten-gigabitethernet 1/0/18
 description router-management
 port link-type access
 port access vlan 1
 jumboframe enable
 stp edged-port
 stp root-protection
 dhcp snooping trust
 ipv6 dhcp snooping trust
 ipv6 nd detection trust
 ipv6 nd raguard role router

# to access-switch, LACP 900
interface ten-gigabitethernet 1/0/19
 description access-switch
 port link-type trunk
 port trunk permit vlan 1 10 200 210 1000
 jumboframe enable
 stp root-protection
 dhcp snooping rate-limit 64
 dhcp snooping check request-message
 dhcp snooping check mac-address
 ipv6 dhcp snooping rate-limit 64
 ipv6 dhcp snooping check request-message
 ipv6 nd raguard role host

# to Router, LACP 1000
interface bridge-aggregation 1000
 description router-trunk
 link-aggregation mode dynamic
 port link-type trunk
 port trunk permit vlan 10 100 200 210 1000
 jumboframe enable
 stp edged-port
 stp root-protection
 dhcp snooping trust
 ipv6 dhcp snooping trust
 ipv6 nd detection trust
 ipv6 nd raguard role router

interface ten-gigabitethernet 1/0/21
 port link-aggregation group 1000

interface ten-gigabitethernet 1/0/22
 port link-aggregation group 1000

interface ten-gigabitethernet 1/0/23
 port link-aggregation group 1000

interface ten-gigabitethernet 1/0/24
 port link-aggregation group 1000

# VIF & DHCP & IPv6 & Multicast & mDNS
# DHCP Server at x.x.x.254
interface vlan-interface 1
 ip address 10.0.0.1 24
 ipv6 address auto
 ipv6 dhcp client pd 1 rapid-commit option-group 1
 ipv6 dhcp client stateless enable
 local-proxy-nd enable
 ospfv3 1 area 0

interface vlan-interface 10
 ip address 10.0.10.1 24
 ipv6 address auto
 ipv6 dhcp client pd 10 rapid-commit option-group 10
 ipv6 dhcp client stateless enable
 local-proxy-nd enable
 ospfv3 1 area 0

interface vlan-interface 100
 ip address 10.10.0.1 24
 bfd min-transmit-interval 400
 bfd min-receive-interval 400
 bfd detect-multiplier 5
 ipv6 address auto
 ipv6 dhcp client pd 100 rapid-commit option-group 100
 ipv6 dhcp client stateless enable
 local-proxy-nd enable
 ospfv3 1 area 0
 igmp enable

interface vlan-interface 200
 ip address 10.20.0.1 24
 ipv6 address auto
 ipv6 dhcp client pd 200 rapid-commit option-group 200
 ipv6 dhcp client stateless enable
 local-proxy-nd enable
 ospfv3 1 area 0
 igmp enable
 pim dm

interface vlan-interface 210
 ip address 10.20.10.1 24
 ipv6 address auto
 ipv6 dhcp client pd 210 rapid-commit option-group 210
 ipv6 dhcp client stateless enable
 local-proxy-nd enable
 ospfv3 1 area 0
 igmp enable
 pim dm

# : save
display current-configuration diff
save safely main

# : check
display link-aggregation summary
display bfd session
display bgp peer
display ospf peer
display stp brief
display vlan
