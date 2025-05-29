# Domains

- using https for both internal and external domains;
- tls using public domain with cloudflare dns-01 support;
- router using `homelab.internal` as DHCP search domain; `exarch-0n` to `10.10.0.101-103` via DHCP;
- extra router domains list below

| FQDN                 | IP         |
| -------------------- | ---------- |
| nas.homelab.internal | 10.10.0.10 |
| s3.homelab.internal  | 10.10.0.10 |

## API Loadbalancing

- Talos: Endpoint => ControlPlane IPs; not support HTTP/S Proxy;
- K8S: Endpoint => Domain, VIP, ControlPlane IPs;
- Endpoint Domain points to ControlPlane IPs;
