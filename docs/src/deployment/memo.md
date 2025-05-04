# Memo

- `hostLegacyRouting:true` conflict wih BIGTCP and BBR, disabled; hence `forwardKubeDNSToHost` is disabled; [ref](https://github.com/siderolabs/talos/issues/10002#issuecomment-2557069620);
- use hardcoded securityContext instead of kyverno;
- external nfs_v4.2 backup using `uid:gid = 2000:2000`;
- media stored in external nas-nfs, using `documents,movie,music,tv-shows` folders;
- test env using proxmox-vm, with secureboot enabled, subnet `172.19.82.0/24`;

## Infra

- vlan is managed by switch as ACCESS mode;
- openebs-hostpath, deprecated due to MS-01 using 256G system disk;
- ceph-block, for database and apps;
- ceph-fs, deprecated, use nas-nfs for shared media;
- ceph-s3, deprecated, use nas-nfs for volsync backup;
- volsync nfs-backup using mutatingAdmissionPolicy;
- onepassword as main secret store;
- use Valkey instead of Dragonflydb if apps served <= 2;

## Deployment

- `10.10.0.10` as `nas.homelab.internal`, provide `dns` / `ntp` / `talos-api` / `nfs` / ...;
- `10.10.0.100` as `k8s.homelab.internal`, VIP;
- `10.10.0.101-103` as `exarch-0n.homelab.internal`, nodes;
- `10.10.0.201-250` as cilium l2 loadbalancer ip;
- self-hosted-runners, label:arc-homelab / label:arc-homelab-ops;

### Bootstrap

```shell
# op signin, then
cd homelab-ops
eval $(op signin)

## dev-env method-1, or direnv
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

## Flux Debug
task reconcile
flux get sources git gitops-system
flux get all -A --status-selector ready=false

kubectl -n gitops-system get fluxreport/flux -o yaml
kubectl -n gitops-system events --for FluxInstance/flux
kubectl -n gitops-system logs deployment/flux-operator

```

## Talos Reset

```shell
## Hic sunt leones.
talosctl reset --system-labels-to-wipe STATE --system-labels-to-wipe EPHEMERAL --graceful=false --wait=false --reboot
```
