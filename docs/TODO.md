# TODO

- [ ] put more secrets into 1password, check "kubernetes/bootstrap/templates/resources.yaml.j2" and "kubernetes/talos/talsecret.yaml"
- [ ] fix system-upgrade-controller installer-id
- [ ] bring up new cluster
- [ ] tune monitoring apps
- [ ] relocate privieged apps to "privileged", with "labels.pod-security.kubernetes.io/enforce: privileged", like "spegel".
- [ ] consider adding [MAP](https://github.com/kubernetes/enhancements/tree/master/keps/sig-api-machinery/3962-mutating-admission-policies) when beta, [examples](https://github.com/search?q=repo%3Abjw-s-labs%2Fhome-ops+MutatingAdmissionPolicy&type=commits).
- [ ] update github webooks url, [ref](https://fluxcd.io/flux/guides/webhook-receivers/#define-a-git-repository-receiver);

## Infra

- `infra/scripts/minio-bucket-keys.sh`, create minio buckets, service accounts and policies for k8s apps, using 1password keys.
- offsite backup ( volsync ) use minio @ nix-infra;
- openebs-hostpath, disabled due to MS-01 using 256G system disk;
- openebs-rep3, for database and apps;
- openebs-rep1, for tmp and cache;

## Pre-deployment

- `10.10.0.10` as nix-infra node, minio / dns / ntp / talos-api / ...
- `10.10.0.11-13` as k8s nodes;
- `10.10.0.101-250` as cilium l2 loadbalancer ip;
- monitoring: `mon.noirprime.com`, `/coroot/` for coroot, `/grafana/` for grafana
- self-hosted-runner, label:arc-homelab / label:arc-homelab-ops

## Github-secrets

- LAB_ASSISTANT_APP_ID => GITHUB_APP_ID
- LAB_ASSISTANT_APP_KEY => GITHUB_APP_KEY
- KUBECONFIG => `base64 kubeconfig > kubeconfig_base64`

## defaults

- doamin = "cluster.local"
- VOLSYNC_STORAGECLASS=openebs-rep3
- VOLSYNC_CACHE_SNAPSHOTCLASS=-openebs-rep1
- VOLSYNC_SNAPSHOTCLASS=openebs-snapshot

## Hardware

- Node: Miniforum MS-01 X3
- CPU: Intel 13900H
- RAM: Crucial DDR5 5600MHz 48G X2
- SystemDisk: Advantech A+E 2230 SSD 256G, replace WIFI
- StorageDisk1: SK Hynix P31 2TB
- StorageDisk2: SK Hynix P41 2TB
- StorageDisk3: Kioxia CM6/CD6 10+TB
- Switch1: H3C S6300-48S
