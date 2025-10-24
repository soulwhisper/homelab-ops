## All-in-one Ceph

- in-cluster `ceph-filesystem` with ec21 for media files;
- in-cluster `ceph-bucket` with rep3 for snapshots;
- too many PGs per OSD for 3 nodes;
- deprecated

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
