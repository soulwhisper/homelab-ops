#!/bin/bash
# : This script configures H3C S6520-24S-SI as core switch for a homelab environment
# : It sets up VLANs, LACP, BGP, DHCP, and other necessary configurations
# : If pasted into the switch console, make sure to paste by phases to avoid errors

# :: system basics
system-view
sysname H3C-Core-Switch
clock timezone beijing add 08:00:00
domain default enable system

undo ip http enable
undo ip https enable
ssh server enable
stelnet server enable

# :: vlan configuration
vlan 10
 name MGMT
vlan 100
 name LAB
vlan 200
 name LAN
vlan 300
 name WIFI
vlan 310
 name IOT

# :: LACP configuration
interface Bridge-Aggregation1
 description K8S-Node1_Bond
 link-aggregation mode dynamic
 port access vlan 100

interface Bridge-Aggregation2
 description K8S-Node2_Bond
 link-aggregation mode dynamic
 port access vlan 100

interface Bridge-Aggregation3
 description K8S-Node3_Bond
 link-aggregation mode dynamic
 port access vlan 100

lacp global system-priority 32768
lacp global period short

# :: interface configuration
interface GigabitEthernet1/0/1
 port link-mode bridge
 port access vlan 10
 description To_MGMT_Switch

interface GigabitEthernet1/0/2
 port link-mode bridge
 port link-aggregation group 1
 description To_K8S-Node1_1

interface GigabitEthernet1/0/3
 port link-mode bridge
 port link-aggregation group 1
 description To_K8S-Node1_2

interface GigabitEthernet1/0/4
 port link-mode bridge
 port link-aggregation group 2
 description To_K8S-Node2_1

interface GigabitEthernet1/0/5
 port link-mode bridge
 port link-aggregation group 2
 description To_K8S-Node2_2

interface GigabitEthernet1/0/6
 port link-mode bridge
 port link-aggregation group 3
 description To_K8S-Node3_1

interface GigabitEthernet1/0/7
 port link-mode bridge
 port link-aggregation group 3
 description To_K8S-Node3_2

interface GigabitEthernet1/0/20
 port link-mode bridge
 port access vlan 200
 description To_Office_Network

interface GigabitEthernet1/0/23
 port link-mode bridge
 port link-type trunk
 port trunk permit vlan 300 310
 port trunk pvid vlan 1
 description To_Wireless_AP

interface GigabitEthernet1/0/24
 port link-mode bridge
 port link-type trunk
 port trunk permit vlan 10 100 200 300 310
 description Uplink_to_OPNsense

# :: vlan interface configuration
interface Vlan-interface10
 ip address 10.0.10.1 255.255.255.0
 description MGMT_Network

interface Vlan-interface100
 ip address 10.10.0.1 255.255.255.0
 description LAB_Network

interface Vlan-interface200
 ip address 10.20.0.1 255.255.255.0
 description LAN_Network

interface Vlan-interface300
 ip address 10.30.0.1 255.255.255.0
 description WIFI_Network

interface Vlan-interface310
 ip address 10.30.10.1 255.255.255.0
 description IOT_Network

# :: route configuration
router id 10.0.10.1
ip route-static 0.0.0.0 0.0.0.0 10.0.10.254

ip ip-prefix INTERNAL_NETWORKS index 10 permit 10.0.0.0 8 ge 24 le 24
ip ip-prefix DEFAULT_ROUTE index 10 permit 0.0.0.0 0
ip ip-prefix K8S_SUBNETS index 10 permit 10.100.0.0 16

route-policy RECOVER permit node 10
 apply dampening 15 750 3000 60

route-policy EXPORT_TO_OPNSENSE permit node 10
 if-match ip-prefix INTERNAL_NETWORKS
 apply community no-export

route-policy IMPORT_FROM_OPNSENSE permit node 10
 if-match ip-prefix DEFAULT_ROUTE
 apply local-preference 200

route-policy K8S_POD_ROUTES permit node 10
 if-match ip-prefix K8S_SUBNETS
 apply community 65510:100

# :: BGP configuration
bgp 65510
 timer keepalive 3 hold 9
 graceful-restart
 graceful-restart timer restart 120
 graceful-restart timer wait-for-rib 180
 graceful-restart peer-reset
 auto-recovery interval 60
 dampening route-policy RECOVER

 address-family ipv4
  network 10.0.10.0 255.255.255.0
  network 10.10.0.0 255.255.255.0
  network 10.20.0.0 255.255.255.0
  network 10.30.0.0 255.255.255.0
  network 10.30.10.0 255.255.255.0

  aggregate 10.10.0.0 24 detail-suppressed

  peer 10.0.10.254 as-number 65500
  peer 10.0.10.254 description OPNsense_Firewall
  peer 10.0.10.254 route-policy EXPORT_TO_OPNSENSE out
  peer 10.0.10.254 route-policy IMPORT_FROM_OPNSENSE in
  peer 10.0.10.254 advertise-community

 quit

 group k8s internal
  peer k8s reflect-client
  peer k8s next-hop-local
  peer k8s ignore first-as
  peer k8s connect-retry 5
  peer k8s graceful-restart
  peer k8s capability-advertise route-refresh
  peer k8s tcp-mss 1024
  peer k8s tcp-keepalive 10 3
  peer k8s route-policy K8S_POD_ROUTES in

  peer 10.10.0.101 group k8s description K8S-Node1
  peer 10.10.0.102 group k8s description K8S-Node2
  peer 10.10.0.103 group k8s description K8S-Node3

# :: DHCP configuration
dhcp enable
dhcp server ip-pool LAB_VLAN100
 gateway-list 10.10.0.1
 network 10.10.0.0 mask 255.255.255.0
 dns-list 10.0.10.254
 excluded-ip-address 10.10.0.1 10.10.0.100

dhcp server ip-pool LAN_VLAN200
 gateway-list 10.20.0.1
 network 10.20.0.0 mask 255.255.255.0
 dns-list 10.0.10.254
 excluded-ip-address 10.20.0.1 10.20.0.100

# :: Others
# :: Admin configuration is removed
lldp global enable

# :: Save configuration
return
save force

# :: Checks
display current-configuration

display bgp peer

display interface brief
