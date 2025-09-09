## Memo

- Workstation stick with NixOS, `Nix-Ops` [ref](https://github.com/soulwhisper/nix-config/tree/main/hosts/nix-ops);
- `hostLegacyRouting:true` conflict wih BIGTCP and BBR, disabled; hence `forwardKubeDNSToHost` is disabled; [ref](https://github.com/siderolabs/talos/issues/10002#issuecomment-2557069620);
- using hardcoded securityContext instead of kyverno;
- external nfs_v4.2 backup using `uid:gid = 2000:2000`;
- test env using proxmox-vm, with secureboot enabled, subnet `172.19.82.0/24`;
- The Flux objects are created in the same namespace where the `FluxInstance` is deployed using the namespace name as the Flux source and Kustomization name;
- `Talhelper` is not deprecated due to the simplicity and maintainability it provides, deprecated tasks [ref](https://github.com/bjw-s-labs/home-ops/commit/44999bfa6e2764de3c0030321018d1bfa2748817);

### Infra

- vlan is managed by switch as ACCESS mode;
- openebs-hostpath, deprecated due to MS-01 using 256G system disk;
- ceph-block, for database and apps;
- nfs, for shared media;
- s3 for volsync backup;
- volsync nfs-backup, deprecated, using mutatingAdmissionPolicy;
- onepassword as main secret store;
- externaldns-adguard store records in `custom-adblock` field;
- internal and external domains both using `noirprime.com`, powered by cloudflared;

#### Proxy

- `HTTPS GET` / `HTTPS POST`, should set `https_proxy`;
- no_proxy = `.cluster.local.,.cluster.local,.svc,localhost,127.0.0.1,{pod-subnet},{svc-subnet}`;

#### Replicas

- production, replica >= 2;
- homelab, cni/gateway/ingress = 3, others = 1;

### Bootstrap

```shell
cd homelab-ops
direnv allow

eval $(op signin)

# bootstrap, mode='prod'
just talos image prod
just talos generate prod
just bootstrap

# check
kubectl get ks -A
kubectl get hr -A

# reboot each machine at least once before any upgrade to ensure proxy env propagated

## Flux Debug
task reconcile
flux get sources git gitops-system
flux get all -A --status-selector ready=false

kubectl -n gitops-system get fluxreport/flux -o yaml
kubectl -n gitops-system events --for FluxInstance/flux
kubectl -n gitops-system logs deployment/flux-operator

## update flux-webhook
## https://fluxcd.io/flux/guides/webhook-receivers/
kubectl -n gitops-system get receivers.notification.toolkit.fluxcd.io

## resource optimization
popeye -A -s statefulsets
kubectl resource-capacity --available
kubectl resource-capacity -p -c -u -n database-system

## trigger healthcheck
kubectl create job --from=cronjob/talos-healthcheck talos-hc -n gitops-system
```

#### VM test issues

- only `proxmox` support secureboot and vip;
- virtual disks, will make rook-ceph-osd-prepare `0/1 completed` forever;
- virtual nic not support BIGTCP and XDP;
- dragonfly needs `avx`, cpu should be `host` model;

### Go-task checks

```shell
## talos config check
talosctl config info

## talos cluster connectivity
talosctl get members

## k8s cluster connectivity
kubectl get nodes

```
