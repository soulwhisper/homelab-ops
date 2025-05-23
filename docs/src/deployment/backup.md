# Backups

- use local-s3:minio instead of remote-s3:cloudflare-r2 for snapshots;
- use nfs for shared-media files;

## S3

| app               | bucket     | key-name   |
| ----------------- | ---------- | ---------- |
| dragonfly-operator | dragonfly   | dragonfly   |
| crunchy-pgo       | postgres   | postgres   |
| talos-backup      | talos      | talos      |
| volsync           | volsync    | volsync    |

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
      "Resource": ["arn:aws:s3:::{bucket}/*", "arn:aws:s3:::{bucket}"]
    }
  ]
}
```

## NFS

- use truenas-scale as main nas;
- endpoint: `nas.homelab.internal`;
- shares: `/mnt/Arcanum/shared/media`;
- permissions: `uid:gid=2000:2000`;
- folders: `data` and `comic,ebook,manga,movie,music,photo,tvshow`;
