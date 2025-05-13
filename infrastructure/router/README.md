# Router

## Intro

- This is the Kubernetes support node for my homelab-ops environment;
- Also functions as a dedicated router for the Kubernetes subnet;
- Using `vyos-stream` instead of a `debian+docker` stack;

## Components

- DHCP Server, domain-name = `homelab.internal`;
- DNS, forward to alidns, ddns using rfc-2136, backed by powerdns;
- NTP, nts using `time.cloudflare.com`;
- Protocols support: BGP / BFD;
- Containers: talos-api, proxy;

## Bootstrap

```shell
# req.min: 2C4G 10GB

# disable secureboot, use iso, login as vyos:vyos
install image
reboot

# bootstrap
configure
load /opt/vyatta/etc/config/config.boot
set interfaces ethernet eth0 description 'MGMT'
set interfaces ethernet eth0 address '10.10.0.10/24'
set service ssh
commit
save

## temp, for password login
sudo nano /etc/ssh/sshd_config # PasswordAuthentication yes
sudo systemctl restart ssh

## login via ssh, copy `config` and `apply-config.sh`
./apply-config.sh

```
