#!/bin/vbash

# BGP; TCP 179
set protocols bgp system-as 65510
set protocols bgp parameters router-id '10.10.0.1'
set protocols bgp address-family ipv4-unicast aggregate-address 10.10.0.0/24
set protocols bgp address-family ipv4-unicast maximum-paths ebgp 1
set protocols bgp address-family ipv4-unicast redistribute connected

set protocols bgp peer-group k8s
set protocols bgp peer-group k8s remote-as '65512'
set protocols bgp peer-group k8s address-family ipv4-unicast nexthop-self
set protocols bgp peer-group k8s address-family ipv4-unicast soft-reconfiguration inbound
set protocols bgp neighbor 10.10.0.101 peer-group k8s
set protocols bgp neighbor 10.10.0.102 peer-group k8s
set protocols bgp neighbor 10.10.0.103 peer-group k8s

# BFD; UDP 3784
set protocols bgp peer-group k8s bfd
set protocols bfd peer 10.10.0.101 interval 300 multiplier 3
set protocols bfd peer 10.10.0.102 interval 300 multiplier 3
set protocols bfd peer 10.10.0.103 interval 300 multiplier 3
