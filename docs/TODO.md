# TODO

- [ ] add a special openebs storageclass for tmpfs, i.e. actions-runner
- [ ] put more secrets into 1password, check "kubernetes/bootstrap/templates/resources.yaml.j2" and "kubernetes/talos/talsecret.yaml"
- [ ] fix system-upgrade-controller installer-id
- [ ] bring up new cluster
- [ ] tune monitoring apps
- [ ] relocate privieged apps to "privileged", with "labels.pod-security.kubernetes.io/enforce: privileged", like "spegel".
- [ ] update github webooks url, [ref](https://fluxcd.io/flux/guides/webhook-receivers/#define-a-git-repository-receiver);

## Infra

- `infra/scripts/minio-bucket-keys.py`, create minio buckets, service accounts and policies for k8s apps, using 1password keys.

## Pre-deployment

- only hostname use `homelab.internal`
- `172.19.82.10`, clash-proxy / adguard / minio / traefik, dns-01, `s3.noirprime.com`
- `172.19.82.201-250` used as cilium l2 loadbalancer ip
- s3: `s3.noirprime.com`, minio, create buckets, assgin keys; traefik-dns-01;
- mon: `mon.noirprime.com`, `/coroot/` for coroot, `/grafana/` for grafana
- cilium use interface:bond0, currently only one interface in VM
- self-hosted-runner, label:arc-homelab

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

## Changelog

- remove `/kubernetes/bootstrap/flux/kustomization.yaml`
- archive old monitoring system; replace with coroot as general board, clickhouse-qryn-alloy-grafana as backups;
