## Memo (WIP)

- bring up new cluster, using secureboot ISO, not pxe/matchbox
- add github webooks after deployment, [ref](https://fluxcd.io/flux/guides/webhook-receivers/#define-a-git-repository-receiver);
- tune monitoring apps
- relocate privieged apps to "privileged", with "labels.pod-security.kubernetes.io/enforce: privileged", like "spegel".
- consider adding [MAP](https://github.com/kubernetes/enhancements/tree/master/keps/sig-api-machinery/3962-mutating-admission-policies) when beta, [examples](https://github.com/search?q=repo%3Abjw-s-labs%2Fhomelab-ops+MutatingAdmissionPolicy&type=commits).
- use "sigs.k8s.io/controller-tools/cmd/controller-gen" to update volsync replicationsource/replicationdestination schema
- add discord notifications for github actions;
- migrated from mayastor to ceph; disable ceph-nfs;

### Infra

- `infra/scripts/minio-bucket-keys.sh`, create minio buckets, service accounts and policies for k8s apps, using 1password keys.
- offsite backup ( volsync ) use minio @ nix-infra;
- openebs-hostpath, disabled due to MS-01 using 256G system disk;
- ceph-block, for database and apps;
- ceph-fs, for shared-media;
- ceph-s3, for volsync backup;
- sops.age for configs, migrating to onepassword;
- onepassword, main secret store;

### Pre-deployment

- set `exarch-0n` and `k8s.homelab.internal` to IPs;
- make sure system-upgrade-controller use correct installer and schematicID;
- `10.10.0.10` as nix-infra node, dns / ntp / talos-api / ...;
- `10.10.0.100` as VIP, but not functional during bootstrap;
- `10.10.0.101-103` as k8s nodes;
- `10.10.0.201-250` as cilium l2 loadbalancer ip;
- self-hosted-runner, label:arc-homelab / label:arc-homelab-ops;

### Bootstrp

```shell
# op signin, then
cd homelab-ops
eval $(op signin)

## dev-env method-1
export ROOT_DIR=$PWD
export KUBECONFIG=$ROOT_DIR/kubernetes/infrastructure/talos/clusterconfig/kubeconfig
export TALOSCONFIG=$ROOT_DIR/kubernetes/infrastructure/talos/clusterconfig/talosconfig
export MINIJINJA_CONFIG_FILE=$ROOT_DIR/.minijinja.toml
## dev-env method-2
devenv shell
## dev-env method-3
mise env -s fish | source

# init
task talos:generate-clusterconfig
task k8s-bootstrap:talos
task k8s-bootstrap:apps

# deploy
task flux:apply-ks DIR=storage-system
task flux:apply-ks DIR=security-system
task flux:apply-ks DIR=monitoring-system
task flux:apply-ks DIR=networking-system
## deploy others
```

### App Memo

- use Valkey instead of Dragonflydb if apps served <= 2;

### Overengineering

- NTS support servers in NTP config;
- Disk encryption for homelab env;
