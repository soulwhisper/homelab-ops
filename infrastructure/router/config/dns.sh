#!/bin/vbash

# DNS
set service dns forwarding system
set service dns forwarding cache-size 4000000
set service dns forwarding listen-address 10.10.0.1

set service dns forwarding authoritative-domain homelab.internal records a k8s 10.10.0.101
set service dns forwarding authoritative-domain homelab.internal records a k8s 10.10.0.102
set service dns forwarding authoritative-domain homelab.internal records a k8s 10.10.0.103
set service dns forwarding authoritative-domain homelab.internal records a exarch-01 10.10.0.101
set service dns forwarding authoritative-domain homelab.internal records a exarch-02 10.10.0.102
set service dns forwarding authoritative-domain homelab.internal records a exarch-03 10.10.0.103
set service dns forwarding authoritative-domain homelab.internal records a nas 10.10.0.10
set service dns forwarding authoritative-domain homelab.internal records a s3 10.10.0.10

set service dns dynamic name LAB server 10.10.0.1
set service dns dynamic name LAB zone 'homelab.internal'
set service dns dynamic name LAB key '/config/homelab.key'
