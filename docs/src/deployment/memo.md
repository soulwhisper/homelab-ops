# Memo

- bring up new cluster, using secureboot ISO, not pxe/matchbox;
- migrated from mayastor to ceph; disable ceph-nfs;
- `hostLegacyRouting:true` conflict wih BIGTCP and BBR, disabled; hence `forwardKubeDNSToHost` is disabled; [ref](https://github.com/siderolabs/talos/issues/10002#issuecomment-2557069620);
- use hardcoded securityContext instead of kyverno;
- external nfs_v4.2 backup using `uid:gid = 2000:2000`;
- media stored in external nas-nfs, using `documents,movie,music,tv-shows` folders;
- if not test, vlan is managed by talos itself;

## Infra

- `infra/scripts/minio-bucket-keys.sh`, create minio buckets, service accounts and policies for k8s apps, using 1password keys.
- offsite backup ( volsync ) use minio @ nix-infra;
- openebs-hostpath, disabled due to MS-01 using 256G system disk;
- ceph-block, for database and apps;
- ceph-fs, deprecated, use nas-nfs for shared media;
- ceph-s3, deprecated, use nas-nfs for volsync backup;
- volsync nfs-backup using mutatingAdmissionPolicy;
- onepassword as main secret store;
- use Valkey instead of Dragonflydb if apps served <= 2;

### Over-engineering

- NTS support servers in NTP config;
- Disk encryption for homelab env;

## Deployment

- set `exarch-0n.homelab.internal` and `k8s.homelab.internal` to IPs at DNS node;
- `10.10.0.10` as `nas.homelab.internal`, provide `dns` / `ntp` / `talos-api` / `nfs` / ...;
- `10.10.0.100` as VIP;
- `10.10.0.101-103` as k8s nodes;
- `10.10.0.201-250` as cilium l2 loadbalancer ip;
- self-hosted-runners, label:arc-homelab / label:arc-homelab-ops;
- production subnet needs dhcp;

### Bootstrap

```shell
# op signin, then
cd homelab-ops
eval $(op signin)

## dev-env method-1
export KUBECONFIG=$PWD/kubernetes/infrastructure/talos/clusterconfig/kubeconfig
export TALOSCONFIG=$PWD/kubernetes/infrastructure/talos/clusterconfig/talosconfig
## dev-env method-2
devenv shell

# bootstrap
task talos:generate-clusterconfig
## if test
task talos:generate-clusterconfig MODE=test

task k8s-bootstrap:talos
task k8s-bootstrap:apps

# check
kubectl get ks -A
kubectl get hr -A
```

### Flux Debug

```shell
task reconcile
flux check
flux get sources git gitops-system

kubectl -n gitops-system get fluxreport/flux -o yaml
kubectl -n gitops-system events --for FluxInstance/flux
kubectl -n gitops-system logs deployment/flux-operator
flux -n gitops-system get all -A --status-selector ready=false

```

### Talos Reset

```shell
## Hic sunt leones.
talosctl reset --system-labels-to-wipe STATE --system-labels-to-wipe EPHEMERAL --graceful=false --wait=false --reboot
```
