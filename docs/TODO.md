# TODO

- [ ] observability apps need more tuning later
- [ ] tunning in-cluster github-action-runner, label:arc-homelab-talos; add LAB_ASSISTANT_APP_ID/LAB_ASSISTANT_APP_KEY.

## Pre-deployment

- only hostname use `homelab.internal`
- `172.19.82.10`, clash-proxy / adguard / minio / traefik, dns-01, `s3.noirprime.com`
- `172.19.82.201-250` used as cilium l2 loadbalancer ip
- s3: `s3.noirprime.com`, create buckets, assgin keys
- nfs: `nas.noirprime.com`, `/mnt/pool_hdd/media`, for calibre-web
- cilium use interface:bond0, currently only one interface in VM

## Sub-domains

- s3 = minio; deploy with traefik dns-01 at nas, enable https
- nas = truenas
- hubble-main = kube-system/cilium-hubble
- grafana = obeservability/grafana
- loki = obeservability/loki
- kromgo = obeservability/kromgo
- paperless = media/paperless
- calibre-web = media/calibre-web

## defaults

- doamin = "cluster.local"
- VOLSYNC_STORAGECLASS=openebs-rep2
- VOLSYNC_SNAPSHOTCLASS=openebs-snapshot

## SOPS

- [X] /kubernetes/main/flux/vars/cluster-secrets.sops.yaml, CLUSTER_SECRET_CPGO_R2_ENDPOINT
- [X] /kubernetes/main/bootstrap/flux/age-key.sops.yaml, age.agekey
- [X] /kubernetes/main/bootstrap/talos/talenv.sops.yaml
- [X] /kubernetes/main/bootstrap/talos/talsecret.sops.yaml
- [X] /kubernetes/main/apps/security/onepassword-connect/app/secret.sops.yaml, 1password-credentials.json, token

## kustomization removed

- /kubernetes/main/bootstrap/flux/kustomization.yaml
