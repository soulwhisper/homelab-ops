# Archived

- This folder contains operational but deprecated configs;
- authelia/lldap [ref](https://github.com/search?q=repo%3Amchestr%2Fhome-cluster%20OAUTH_CLIENT&type=code), homepage [ref](https://github.com/search?q=repo%3Amchestr%2Fhome-cluster+gethomepage&type=code);

## List

> components

- gatus
- sops
- volysnc:ceph-s3

> kubernetes:base

- crds:gateway-api
- apps:ingress-nginx

> kubernetes:database

- apps:emqx-operator
- apps:crunchy-postgres-operator

> kubernetes:management

- ns:crossplane-system
- ns:karmada-system

> kubernetes:media

- apps:alist
- apps:auto-bangumi
- apps:komga
- apps:ytdl-sub

> kubernetes:monitor

- apps:alertmanager
- apps:echo-server
- apps:gatus
- apps:loki
- apps:kube-prometheus-stack
- apps:kube-state-metrics
- apps:node-exporter
- apps:promtail

> kubernetes:networking

> kubernetes:security

- apps:authelia
- apps:kyverno
- apps:lldap

> kubernetes:selfhosted

> kubernetes:storage

- apps:openebs
- apps:rook-ceph(fs & s3)

> scripts

- minio-bucket-init

## Reasons

- database: prefer native volume management instead of stateful set;
- media: arrs is not my goal;
- monitoring: victroia-stack perform more and cost less, same to fluent-bit; use kromgo and fqdn-ping instead of gatus;
- security: reduce complexity;
- selfhosted: using aqara stack instead of home-assistant;
- storage: migrated to rook-ceph for better support and stability;
