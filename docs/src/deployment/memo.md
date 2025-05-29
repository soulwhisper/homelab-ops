# Memo

- `hostLegacyRouting:true` conflict wih BIGTCP and BBR, disabled; hence `forwardKubeDNSToHost` is disabled; [ref](https://github.com/siderolabs/talos/issues/10002#issuecomment-2557069620);
- use hardcoded securityContext instead of kyverno;
- external nfs_v4.2 backup using `uid:gid = 2000:2000`;
- test env using proxmox-vm, with secureboot enabled, subnet `172.19.82.0/24`;
- use DNS domain instead of `talhelper` default controlPlane IP endpoints;

## Infra

- vlan is managed by switch as ACCESS mode;
- openebs-hostpath, deprecated due to MS-01 using 256G system disk;
- ceph-block, for database and apps;
- ceph-fs, deprecated, use nas-nfs for shared media;
- ceph-s3, deprecated, use nas-minio for volsync backup;
- volsync nfs-backup using mutatingAdmissionPolicy;
- onepassword as main secret store;
- externaldns-adguard store records in `custom-adblock` field;
- internal and external domains both using `noirprime.com`, powered by cloudflared;

### Cloudflare

- cloudflared-tunnel => zero-trust / networks / tunnels
- cloudflare, dns-01, noirprime.com: user-profile =>api-tokens, ZONE:READ / DNS:EDIT

### Proxy

- `HTTPS GET` / `HTTPS POST`, should set `https_proxy`;
-  no_proxy = `.cluster.local.,.cluster.local,.svc,localhost,127.0.0.1,{pod-subnet},{svc-subnet}`;

## Bootstrap

```shell
# op signin first
cd homelab-ops
direnv allow

eval $(op signin)

# bootstrap
task talos:generate-clusterconfig
## if test
task talos:generate-clusterconfig MODE=test

task bootstrap:talos
task bootstrap:apps

# check
kubectl get ks -A
kubectl get hr -A

## Flux Debug
task reconcile
flux get sources git gitops-system
flux get all -A --status-selector ready=false

kubectl -n gitops-system get fluxreport/flux -o yaml
kubectl -n gitops-system events --for FluxInstance/flux
kubectl -n gitops-system logs deployment/flux-operator

## update flux-webhook
## https://fluxcd.io/flux/guides/webhook-receivers/
kubectl -n gitops-system get receivers.notification.toolkit.fluxcd.io

## resource optimization
popeye -A -s statefulsets
kubectl resource-capacity --available
kubectl resource-capacity -p -c -u -n database-system

## trigger healthcheck
kubectl create job --from=cronjob/talos-healthcheck talos-hc -n gitops-system
```

### VM test issues

- only `proxmox` support secureboot and vip;
- virtual disks, will make rook-ceph-osd-prepare `0/1 completed` forever;
- virtual nic not support BIGTCP and XDP;
- dragonfly needs `avx`, cpu should be `host` model;

## Multi-Cluster plan

- homelab using talconfig `prod`; corplab using talconfig `test`;
- multi-cluster flux, [ref](https://github.com/h-wb/home-ops/tree/main);
- multi-cluster talos task, [ref](https://github.com/h-wb/home-ops/blob/main/.taskfiles/Talos/Taskfile.yaml);
- multi-cluster volsync task, [ref](https://github.com/h-wb/home-ops/blob/main/.taskfiles/VolSync/Taskfile.yaml);
