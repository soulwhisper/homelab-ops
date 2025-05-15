# Backups

- use local-s3:minio instead of remote-s3:cloudflare-r2 for snapshots;
- use nfs for shared-media files;

## S3

| app              | bucket           | key-name         |
| ---------------- | ---------------- | ---------------- |
| crunchy-pgo      | postgres         | postgres         |
| talos-backup     | talos            | talos            |
| volsync          | volsync          | volsync          |

### Minio

- minio-app on truenas-scale;
- endpoint = `s3:http://s3.homelab.internal:9000`
- region = us-east-1
- versioning = disabled; object-locking = disabled; quota = disabled;

```json
{
  "Version": "",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": ["arn:aws:s3:::volsync/*", "arn:aws:s3:::volsync"]
    }
  ]
}
```

## NFS

- use truenas-scale as main nas;
- nfs-endpoint: `nas.homelab.internal`;
- nfs-shares: `/mnt/Arcanum/shared/media`;
- nfs-permissions: `uid:gid=2000:2000`;
