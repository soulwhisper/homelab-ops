# Memo

- bring up new cluster, using secureboot ISO, not pxe/matchbox;
- migrated from mayastor to ceph; disable ceph-nfs;
- `hostLegacyRouting: true` conflict wih BIGTCP and BBR, disabled; hence `forwardKubeDNSToHost` is disabled; [ref](https://github.com/siderolabs/talos/issues/10002#issuecomment-2557069620);
- use hardcoded securityContext instead of kyverno;

## Infra

- `infra/scripts/minio-bucket-keys.sh`, create minio buckets, service accounts and policies for k8s apps, using 1password keys.
- offsite backup ( volsync ) use minio @ nix-infra;
- openebs-hostpath, disabled due to MS-01 using 256G system disk;
- ceph-block, for database and apps;
- ceph-fs, for shared-media;
- ceph-s3, for volsync backup;
- onepassword as main secret store;
- use Valkey instead of Dragonflydb if apps served <= 2;

### Overengineering

- NTS support servers in NTP config;
- Disk encryption for homelab env;

## Deployment

- set `exarch-0n` and `k8s.homelab.internal` to IPs;
- `10.10.0.10` as nix-infra node, dns / ntp / talos-api / ...;
- `10.10.0.100` as VIP;
- `10.10.0.101-103` as k8s nodes;
- `10.10.0.201-250` as cilium l2 loadbalancer ip;
- self-hosted-runner, label:arc-homelab / label:arc-homelab-ops;

### Bootstrp

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
task k8s-bootstrap:talos
task k8s-bootstrap:apps

## if failed to pull etcd, restart proxy-service, or reduce VM mtu to 1200

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
