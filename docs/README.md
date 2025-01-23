## GTD

- bring up new cluster, using secureboot ISO, not pxe/matchbox
- add github webooks after deployment, [ref](https://fluxcd.io/flux/guides/webhook-receivers/#define-a-git-repository-receiver);
- tune monitoring apps
- relocate privieged apps to "privileged", with "labels.pod-security.kubernetes.io/enforce: privileged", like "spegel".
- consider adding [MAP](https://github.com/kubernetes/enhancements/tree/master/keps/sig-api-machinery/3962-mutating-admission-policies) when beta, [examples](https://github.com/search?q=repo%3Abjw-s-labs%2Fhome-ops+MutatingAdmissionPolicy&type=commits).
- use "sigs.k8s.io/controller-tools/cmd/controller-gen" to update volsync replicationsource/replicationdestination schema
- add discord notifications for github actions;

## Infra

- `infra/scripts/minio-bucket-keys.sh`, create minio buckets, service accounts and policies for k8s apps, using 1password keys.
- offsite backup ( volsync ) use minio @ nix-infra;
- openebs-hostpath, disabled due to MS-01 using 256G system disk;
- openebs-rep3, for database and apps;
- openebs-rep1, for tmp and cache;
- sops.age for configs, migrating to onepassword;
- onepassword, main secret store;

## Pre-deployment

- make sure system-upgrade-controller use correct installer and schematicID
- `10.10.0.10` as nix-infra node, minio / dns / ntp / talos-api / ...
- `10.10.0.101-103` as k8s nodes;
- `10.10.0.201-250` as cilium l2 loadbalancer ip;
- monitoring: `mon.noirprime.com`, `/coroot/` for coroot, `/grafana/` for grafana
- self-hosted-runner, label:arc-homelab / label:arc-homelab-ops

## Github-secrets

- LAB_ASSISTANT_APP_ID => GITHUB_APP_ID
- LAB_ASSISTANT_APP_KEY => GITHUB_APP_KEY

## defaults

- doamin = "cluster.local"
- VOLSYNC_STORAGECLASS=openebs-rep3
- VOLSYNC_CACHE_SNAPSHOTCLASS=-openebs-rep1
- VOLSYNC_SNAPSHOTCLASS=openebs-snapshot
- app_uid = app_gid = 1001

## volsync-nfs

```yaml
# if using volsync-nfs, add below lines
          volumeMounts:
            - mountPath: /volsync
              name: volsync
      volumes:
        - name: volsync
          nfs:
            server: "nix-infra.homelab.internal"
            path: "/opt/backup/volsync"
```

## Hardware

- Node: Miniforum MS-01 X3
- CPU: Intel 13900H
- RAM: Crucial DDR5 5600MHz 48G X2
- SystemDisk: Advantech A+E 2230 SSD 256G, replace WIFI
- StorageDisk1: SK Hynix P31 2TB
- StorageDisk2: SK Hynix P41 2TB
- StorageDisk3: Kioxia CM6/CD6 10+TB
- Switch1: H3C S6300-48S

## App Memo

- use Valkey instead of Dragonflydb if apps served <= 2;
