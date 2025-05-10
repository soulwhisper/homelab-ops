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
