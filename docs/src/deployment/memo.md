# Memo

- `hostLegacyRouting:true` conflict wih BIGTCP and BBR, disabled; hence `forwardKubeDNSToHost` is disabled; [ref](https://github.com/siderolabs/talos/issues/10002#issuecomment-2557069620);
- use hardcoded securityContext instead of kyverno;
- external nfs_v4.2 backup using `uid:gid = 2000:2000`;
- media stored in external nas-nfs, using `documents,movie,music,tv-shows` folders;
- test env using proxmox-vm, with secureboot enabled, subnet `172.19.82.0/24`;
- `v1.10+` will ignore `.machine.install.extraKernelArgs` and `.machine.install.extensions` fields in talconfig;
- cilium stays at `v1.16.6` until cloudflared mtu issue fixed, [ref](https://github.com/cilium/cilium/issues/37529);

## Infra

- vlan is managed by switch as ACCESS mode;
- openebs-hostpath, deprecated due to MS-01 using 256G system disk;
- ceph-block, for database and apps;
- ceph-fs, deprecated, use nas-nfs for shared media;
- ceph-s3, deprecated, use nas-nfs for volsync backup;
- volsync nfs-backup using mutatingAdmissionPolicy;
- onepassword as main secret store;
- externaldns-adguard store records in `custom-adblock` field;
- internal domains using `homelab.internal`;
- external doamins using `noirprime.com`, powered by cloudflared;

### Cloudflare

- cloudflared-tunnel => zero-trust / networks / tunnels
- cloudflare, dns-01, noirprime.com: user-profile =>api-tokens, ZONE:READ / DNS:EDIT

### Database

- postgres, cpgo; app:immich;
- redis, dragonfly; 0:immich;

## Deployment

- `10.10.0.10` as `nas.homelab.internal`, provide `dns` / `minio` / `nfs` / `ntp` / `talos-api` / ...;
- `10.10.0.101-103` as `exarch-0n.homelab.internal` and `k8s.homelab.internal`, nodes;
- `10.10.0.201-250` as cilium l2 loadbalancer ip;
- self-hosted-runners, label:arc-homelab / label:arc-homelab-ops;

### Proxy

- `cert-manager`, `coroot-operator`, `externaldns-cloudflare`, `flux-operator`, `grafana`, `onepassword-sync`, `pgo` using `HTTPS GET`, should set `https_proxy`;
-  no_proxy = `.cluster.local.,.cluster.local,.svc,localhost,127.0.0.1,{pod-subnet},{svc-subnet}`;
- talos env.proxy for container pulling;

### Bootstrap

```shell
# op signin, then
cd homelab-ops
eval $(op signin)

## dev-env method-1, or direnv
export KUBECONFIG=$PWD/infrastructure/talos/clusterconfig/kubeconfig
export TALOSCONFIG=$PWD/infrastructure/talos/clusterconfig/talosconfig
## dev-env method-2
devenv shell

# bootstrap
task talos:generate-clusterconfig
## if test
task talos:generate-clusterconfig MODE=test

task bootstrap:talos
task bootstrap:apps

# check
kubectl get ks -A
kubectl get hr -A

## Flux Debug
task reconcile
flux get sources git gitops-system
flux get all -A --status-selector ready=false

kubectl -n gitops-system get fluxreport/flux -o yaml
kubectl -n gitops-system events --for FluxInstance/flux
kubectl -n gitops-system logs deployment/flux-operator

## Talos Reset
talosctl reset --system-labels-to-wipe STATE --system-labels-to-wipe EPHEMERAL --graceful=false --wait=false --reboot

## Node-level cloudflared debug, with v2024.12.2+
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/bin/cloudflared
chmod +x /usr/bin/cloudflared
curl 172.19.82.101:2000/diag/tunnel
cloudflared tunnel diag --metrics 172.19.82.101:2000

## update flux-webhook
## https://fluxcd.io/flux/guides/webhook-receivers/
kubectl -n gitops-system get receivers.notification.toolkit.fluxcd.io
```

## VM test issues

- only `proxmox` support secureboot and vip;
- virtual disks, will make rook-ceph-osd-prepare `0/1 completed` forever;
- virtual nic not support BIGTCP and XDP;

## Multi-Cluster plan

- homelab using talconfig `prod`; corplab using talconfig `test`;
- multi-cluster flux, [ref](https://github.com/h-wb/home-ops/tree/main);
- multi-cluster talos task, [ref](https://github.com/h-wb/home-ops/blob/main/.taskfiles/Talos/Taskfile.yaml);
- multi-cluster volsync task, [ref](https://github.com/h-wb/home-ops/blob/main/.taskfiles/VolSync/Taskfile.yaml);
