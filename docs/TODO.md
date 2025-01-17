# TODO

- [ ] add a special openebs storageclass for tmpfs, i.e. actions-runner
- [ ] put more secrets into 1password, check "kubernetes/bootstrap/templates/resources.yaml.j2" and "kubernetes/talos/talsecret.yaml"
- [ ] fix system-upgrade-controller installer-id
- [ ] bring up new cluster
- [ ] tune monitoring apps
- [ ] relocate privieged apps to "privileged", with "labels.pod-security.kubernetes.io/enforce: privileged", like "spegel".
- [ ] consider adding [MAP](https://github.com/kubernetes/enhancements/tree/master/keps/sig-api-machinery/3962-mutating-admission-policies) when beta, [examples](https://github.com/search?q=repo%3Abjw-s-labs%2Fhome-ops+MutatingAdmissionPolicy&type=commits).
- [ ] update github webooks url, [ref](https://fluxcd.io/flux/guides/webhook-receivers/#define-a-git-repository-receiver);

## Infra

- `infra/scripts/minio-bucket-keys.py`, create minio buckets, service accounts and policies for k8s apps, using 1password keys.
- offsite backup ( volsync ) using minio @ nix-infra;
- since migrated to MS-01, openebs-hostpath is disabled with using 256G system disk.

## Pre-deployment

- `10.10.0.11-13` as k8s nodes
- `10.10.0.101-250` as cilium l2 loadbalancer ip
- minio: `s3.noirprime.com`, create buckets, assgin keys
- monitoring: `mon.noirprime.com`, `/coroot/` for coroot, `/grafana/` for grafana
- self-hosted-runner, label:arc-homelab / label:arc-homelab-ops

## Deployment-order

- 1, gitops-system
- 2, kube-system, security, storage/openebs
- 3, monitoring
- 4, database
- 5, others

## Github-secrets

- LAB_ASSISTANT_APP_ID => GITHUB_APP_ID
- LAB_ASSISTANT_APP_KEY => GITHUB_APP_KEY
- KUBECONFIG => `base64 kubeconfig > kubeconfig_base64`

## defaults

- doamin = "cluster.local"
- VOLSYNC_STORAGECLASS=openebs-rep2
- VOLSYNC_SNAPSHOTCLASS=openebs-snapshot

## SOPS

- [X] /kubernetes/flux/vars/cluster-secrets.sops.yaml, ~~CLUSTER_SECRET_CPGO_R2_ENDPOINT~~, CF_ACCOUNT_TAG
- [X] /kubernetes/bootstrap/flux/age-key.sops.yaml, age.agekey
- [X] /kubernetes/bootstrap/talos/talenv.sops.yaml
- [X] /kubernetes/bootstrap/talos/talsecret.sops.yaml
- [X] /kubernetes/apps/security/onepassword-connect/app/secret.sops.yaml, 1password-credentials.json, token

## Hardware

- NodeCount: 3
- Frame: Miniforum MS-01
- CPU: Intel 13900H
- RAM: Crucial DDR5 5600MHz 48G X2
- SystemDisk: Advantech A+E 2230 SSD 256G, replace WIFI
- StorageDisk1: SK Hynix P31 2TB X1
- StorageDisk2: SK Hynix P41 2TB X1
- StorageDisk3: Kioxia CM6/CD6 10+TB X1
- Switch: H3C S6300-48S