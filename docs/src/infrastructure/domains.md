## Domains

- using https for both internal and external domains;
- tls using public domain with cloudflare dns-01 support;
- if needing 2+ domains, prefer deeper subs with `Advanced Certificate Manager` support;
- router using `homelab.internal` as DHCP search domain; `exarch-0n` to `10.10.0.101-103` via DHCP;

### API Loadbalancing

- Talos: Endpoint => ControlPlane IPs; not support HTTP/S Proxy;
- K8S: Endpoint => Domain, VIP, ControlPlane IPs;
- Endpoint Domain points to ControlPlane IPs;

### Internal domains

- `noirprime.com` for all k8s services;
- s3 storage (previously `minio`) has migrated to `ceph-bucket`;
- the only `homelab.internal` service used in k8s now is NAS;
- also make sure all k8s node hostname can be resolved in local dns;
