## Proxies

- In my homelab, internet connections, especially to registries, need a corporate proxy;
- However, this HTTP/S based proxy has a negative impact on 'HTTPS POST' and 'QUIC';
- Current solution is "proxies out of cluster", also known as "A pull-through mirror with proxies".

```yaml
# pull through mirror registry, powered by zotregistry
- |-
  machine:
    registries:
      config:
        zot.noirprime.com:
          auth:
            username: admin
            password: ${ZOT_REGISTRY_PASS}
      mirrors:
        docker.io:
          endpoints:
            - https://zot.noirprime.com/docker.io
          overridePath: true
        ghcr.io:
          endpoints:
            - https://zot.noirprime.com/ghcr.io
          overridePath: true
        gcr.io:
          endpoints:
            - https://zot.noirprime.com/gcr.io
          overridePath: true
        registry.k8s.io:
          endpoints:
            - https://zot.noirprime.com/registry.k8s.io
          overridePath: true
        public.ecr.aws:
          endpoints:
            - https://zot.noirprime.com/public.ecr.aws
          overridePath: true
```

```mermaid
flowchart TD
    A[App] -->|Request| B(Spegel)
    B -->|Check Local Cache| C{Cache Hit?}
    C -->|Yes| D[Return Cached Image]
    C -->|No| E[Zotregistry with Proxy]
    E -->|Fetch| F[Public Registry]
    F -->|Response| E
    E -->|Cache & Return| B
    B -->|Deliver| A
```
