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

- make sure system-upgrade-controller use correct installer and schematicID
- `10.10.0.10` as nix-infra node, minio / dns / ntp / talos-api / ...
- `10.10.0.101-103` as k8s nodes;
- `10.10.0.201-250` as cilium l2 loadbalancer ip;
- monitoring: `mon.noirprime.com`, `/coroot/` for coroot, `/grafana/` for grafana
- self-hosted-runner, label:arc-homelab / label:arc-homelab-ops

### defaults

- doamin = "cluster.local"
- app_uid = app_gid = 2000

### App Memo

- use Valkey instead of Dragonflydb if apps served <= 2;

### Overengineering

- NTS support servers in NTP config;
- Disk encryption for homelab env;
