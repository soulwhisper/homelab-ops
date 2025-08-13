## Storage

- cluster `ceph-block` with rep3 for apps;
- cluster `ceph-filesystem` with ec21 for media;
- cluster `ceph-bucket` with rep3 for snapshots;
- manually rsync for snapshot backups;
- USB4 DAS for upgrade backups;

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
