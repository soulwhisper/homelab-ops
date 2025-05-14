# Router

## Intro

- Kubernetes dedicated router for my homelab-ops environment;
- Using `vyos-stream` instead of a `debian+docker` stack;
- this router not forward anything other than dns;

## Components

- DHCP Server, domain-name = `homelab.internal`;
- DNS, forward to alidns, ddns using rfc-2136, backed by powerdns;
- NTP, nts using `time.cloudflare.com`;
- Protocols support: BGP / BFD;
- Containers: talos-api, http-proxy;

## Bootstrap

```shell
# req.min: 4C4G 10GB

# disable secureboot, use iso, login as vyos:vyos
install image
reboot

# bootstrap
configure
set interfaces ethernet eth1 address '10.0.10.10/24'
set service ssh
commit
save

## temp, for password login
sudo nano /etc/ssh/sshd_config # PasswordAuthentication yes
sudo systemctl restart ssh

## login via ssh, copy `config` to `/config`
./apply-config.sh

```
