#!/bin/bash
# This script configures H3C S6520-24S-SI as core switch for a homelab environment
# If pasted into the switch console, make sure to paste by phases to avoid errors

# reset
display default-configuration
restore factory-default
reboot

# defaults
system-view
sysname core-switch

ntp-service enable
clock timezone Beijing add 08:00:00
clock protocol ntp
ntp-service unicast-server 10.10.0.254

interface loopback 0
 ip address 10.255.255.1 255.255.255.255
 bfd min-transmit-interval 400
 bfd min-receive-interval 400
 bfd detect-multiplier 5
router id 10.255.255.1

# security
interface m-gigabitethernet 0/0/0
 ip address 10.0.0.2 24

local-user admin class manage
password simple password
authorization-attribute user-role network-admin
service-type ssh

public-key local create rsa
ssh server enable

acl advanced 3000
 rule 0 permit ip source 10.0.0.0 0.0.0.255 destination 10.0.0.2 0
 rule 100 deny ip

line vty 0 63
 authentication-mode scheme
 acl 3000 inbound
 user-role network-admin

# snooping
dhcp snooping enable
# ipv6 nd detection port-match-ignore

# stp
stp mode rstp
stp instance 0 root primary
stp bpdu-protection

# vlan
vlan 100
dhcp snooping binding record

# eBGP with BFD & OSPF
bfd session init-mode active
bgp 65000
 router-id 10.255.255.1
 timer keepalive 10 hold 30
 group k8s external
  peer k8s bfd
  peer k8s as-number 65100
  peer k8s connect-interface loopback 0
 peer 10.10.0.101 group k8s
 peer 10.10.0.102 group k8s
 peer 10.10.0.103 group k8s
 address-family ipv4
  peer k8s enable

ospf 1 router-id 10.255.255.1
 silent-interface interface vlan-interface 100
 area 0
  network 10.255.255.1 0.0.0.0
  network 10.10.0.0 0.0.0.255

# LACP to K8S
interface bridge-aggregation 10
 description k8s-node-01
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 stp edged-port
 ipv6 nd raguard role host

interface bridge-aggregation 20
 description k8s-node-02
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 stp edged-port
 ipv6 nd raguard role host

interface bridge-aggregation 30
 description k8s-node-03
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 stp edged-port
 ipv6 nd raguard role host

interface ten-gigabitethernet 1/0/1
 port link-aggregation group 10

interface ten-gigabitethernet 1/0/2
 port link-aggregation group 10

interface ten-gigabitethernet 1/0/3
 port link-aggregation group 20

interface ten-gigabitethernet 1/0/4
 port link-aggregation group 20

interface ten-gigabitethernet 1/0/5
 port link-aggregation group 30

interface ten-gigabitethernet 1/0/6
 port link-aggregation group 30

# to nas, LACP 70
interface bridge-aggregation 70
 description nas
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 stp edged-port
 ipv6 nd raguard role host

interface ten-gigabitethernet 1/0/13
 port link-aggregation group 70

interface ten-gigabitethernet 1/0/14
 port link-aggregation group 70

# to Workstation-Fiber, LACP 90
interface bridge-aggregation 90
 description workstation-fiber
 link-aggregation mode dynamic
 port link-type access
 port access vlan 100
 jumboframe enable
 stp edged-port
 ipv6 nd raguard role host

interface ten-gigabitethernet 1/0/17
 port link-aggregation group 90

interface ten-gigabitethernet 1/0/18
 port link-aggregation group 90

# to Router
interface ten-gigabitethernet 1/0/24
 description router-trunk
 port link-type trunk
 port trunk permit vlan 1 10 100 200 210
 stp point-to-point force-true
 dhcp snooping trust
 ipv6 nd raguard role router

# VIF
interface vlan-interface 100
 description lab
 ip address 10.10.0.1 24
 ipv6 address auto

# Routing
# ip route-static 0.0.0.0 0 10.10.0.254
