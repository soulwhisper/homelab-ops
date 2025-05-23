## BGP

```shell
# frr.conf
! -*- bgp -*-
!
! Peer group for k8s
router bgp 65510
bgp ebgp-requires-policy
bgp router-id 10.10.0.1
maximum-paths 1
!
! Peer group for k8s
neighbor k8s peer-group
neighbor k8s remote-as 65512
neighbor k8s activate
neighbor k8s soft-reconfiguration inbound
neighbor k8s timers 15 45
neighbor k8s timers connect 15
!
! Neighbors for k8s
neighbor 10.10.0.101 peer-group k8s
neighbor 10.10.0.102 peer-group k8s
neighbor 10.10.0.103 peer-group k8s
!
address-family ipv4 unicast
redistribute connected
neighbor k8s activate
neighbor k8s route-map ALLOW-ALL in
neighbor k8s route-map ALLOW-ALL out
neighbor k8s next-hop-self
exit-address-family
!
route-map ALLOW-ALL permit 10
!
line vty
!
```
