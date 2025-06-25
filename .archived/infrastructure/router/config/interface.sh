#!/bin/vbash

# LAB
set interfaces ethernet eth0 description 'LAB'
set interfaces ethernet eth0 address '10.10.0.1/24'

# MGMT
set interfaces ethernet eth1 description 'MGMT'
set interfaces ethernet eth1 address '10.0.10.10/24'
