## BGP

```shell
# H3C Switch
router id 10.10.0.1

route-policy RECOVER permit node 10
 apply dampening 15 750 3000 60

bgp 65510
 auto-recovery interval 60
 dampening route-policy RECOVER

 group k8s internal
 peer k8s reflect-client
 peer k8s next-hop-local
 peer 10.10.0.101 group k8s
 peer 10.10.0.102 group k8s
 peer 10.10.0.103 group k8s
 timer keepalive 3 hold 9
 peer k8s connect-retry 5
 peer k8s ignore first-as
 peer k8s timer connect-retry 5
 peer k8s capability-advertise route-refresh
 peer k8s route-update-interval 2
 peer k8s ebgp-interface-sensitive
 peer k8s tcp-mss 1024
 peer k8s tcp-keepalive 10 3

 address-family ipv4
  aggregate 10.10.0.0 24 detail-suppressed
  network 10.10.0.0 24
 quit
```
