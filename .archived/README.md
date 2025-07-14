# Archived

- This folder contains operational but deprecated configs;
- authelia/lldap [ref](https://github.com/search?q=repo%3Amchestr%2Fhome-cluster%20OAUTH_CLIENT&type=code), homepage [ref](https://github.com/search?q=repo%3Amchestr%2Fhome-cluster+gethomepage&type=code);

## List

> infrastructure

- terraform:minio

> taskfiles

- postgres
- reset:minio

> bootstrap

- wipe-rook

> components

- cnpg:nfs-backup
- volsync:nfs-backup

> cronjobs

- cronjob:talos-backup

> kubernetes:database

- apps:emqx-operator

> kubernetes:management

- ns:crossplane-system
- ns:karmada-system

> kubernetes:media

- apps:alist
- apps:auto-bangumi
- apps:komga
- apps:ocis
- apps:ytdl-sub

> kubernetes:monitoring

- apps:echo-server
- apps:fluent-bit

> kubernetes:monitoring:stack

- apps:kube-prometheus-stack
- apps:loki
- apps:promtail

> kubernetes:networking

- apps:externaldns-rfc2136

> kubernetes:security

- apps:authelia
- apps:kyverno
- apps:lldap

> kubernetes:selfhosted

- apps:atuin
- apps:homepage
- apps:voicechat

> kubernetes:selfhosted:automation

- apps:home-assistant
- apps:matter-server
- apps:zigbee2mqtt

> kubernetes:storage

- apps:openebs
- apps:volsync(nfs)

## Reasons

> infrastructure

- minio is deprecated, use ceph-buckets instead;

> database

- prefer cnpg than cpgo;
- emqx is deprecated, like home-assistant;

> media

- prefer emby subscriptions to starrs(usenet) and moviepilot(pt)
- downloaders pair with starrs;

> monitoring

- apprise API too old to use;
- external healthchecks like `cronitor/uptime` is not needed;

> networking

- cilium gateway-api support better than envoy-gateway;
- envoy-gateway-api too big for bootstrap;

> security

- internal network dont need extra auth;

> storage

- rook-ceph has better support than openebs-replicated;
- snapshots to nfs is not planned;
