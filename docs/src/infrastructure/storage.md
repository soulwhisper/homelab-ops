## Storage

- following `3-2-1` strategy;
- cluster `ceph-block` for app;
- cluster `ceph-bucket` for snapshots;
- nas/nfs for media;
- manually rsync for s3 backups;

### ObjectStore

| bucket   | key-name | app           | usage       |
| -------- | -------- | ------------- | ----------- |
| postgres | postgres | cnpg-operator | < 10Gi      |
| volsync  | volsync  | volsync       | < 5\*app Gi |

```shell
# list in-cluster s3 buckets
kubectl rook_ceph --namespace=storage-system --operator-namespace=storage-system \
        radosgw-admin --rgw-realm=ceph-objectstore --rgw-zone=ceph-objectstore \
        bucket list
# check bucket stats
kubectl rook_ceph --namespace=storage-system --operator-namespace=storage-system \
        radosgw-admin --rgw-realm=ceph-objectstore --rgw-zone=ceph-objectstore \
        bucket stats --bucket bucket-name
```

### NFS

- endpoint: `nas.homelab.internal`;
- shares: `/mnt/Arcanum/Media`;
- permissions: `uid:gid=2000:2000, rwx, mapAllUser`;
- folders: `model` and `Downloads,comic,ebook,manga,movie,music,photo,tvshow`;

> NFS-mounts

- since kubernetes version 1.33, `UserNamespaces` becomes default true, nfs mounts have `idmap` issues, [ref](https://kubernetes.io/blog/2025/04/25/userns-enabled-by-default/);
- csi-driver-nfs slow mount issue fixed, [ref](https://github.com/kubernetes-csi/csi-driver-nfs/issues/870);
- so nfs mounts revert to csi-driver;

> NFS-connections

- nfs network status can be monitored via `blackbox-exporter` or kubelet `labels:mountpoint` with `featureGate:CSIVolumeHealth`;

> NFS-snapshots

- previously, using nfs as snapshots destination;
- check `.archived/components` for details;
