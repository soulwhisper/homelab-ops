## TODO

### Infrastructure

- [ ] add switch scripts to infra
- [x] NAS archived, move to CephFS
- [ ] add USB4 DAS backup document

### Talos

- [x] disable swap/zswap
- [ ] migrate disk encryption into UserVolumeConfig, after 1.11

### Apps

- [x] evaluate starrs utility
- [x] fix cloudflared connectivity, via proxies
- [x] optimize ceph-bucket stability

### On-hold

- [ ] Volsync+Kopia, [ref1](https://github.com/perfectra1n/volsync), [ref2](https://github.com/onedr0p/home-ops/blob/main/kubernetes/apps/volsync-system/kopia/app/helmrelease.yaml);
