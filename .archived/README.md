# Archived

- This folder contains operational but deprecated configs;
- authelia/lldap [ref](https://github.com/search?q=repo%3Amchestr%2Fhome-cluster%20OAUTH_CLIENT&type=code), homepage [ref](https://github.com/search?q=repo%3Amchestr%2Fhome-cluster+gethomepage&type=code);

## List

> taskfiles

- postgres

> components

- cnpg:nfs-backup
- gatus
- volysnc:ceph-s3

> kubernetes:base

- apps:ingress-nginx
- crds:gateway-api

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

- apps:externaldns-rfc2136
- apps:envoy-gateway

> kubernetes:security

- apps:authelia
- apps:kyverno
- apps:lldap

> kubernetes:selfhosted

> kubernetes:storage

- apps:openebs
- apps:rook-ceph(fs & s3)

## Reasons

- database: prefer native volume management instead of stateful set;
- media: arrs is not my goal;
- monitoring: victroia-stack perform more and cost less, same to fluent-bit; use kromgo and fqdn-ping instead of gatus;
- security: reduce complexity;
- selfhosted: using aqara stack instead of home-assistant;
- storage: migrated to rook-ceph for better support and stability;
