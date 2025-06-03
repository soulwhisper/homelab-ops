## Backups

- use local-s3:minio instead of remote-s3:cloudflare-r2 for snapshots;
- use nfs for shared-media files;

### S3

| bucket     | key-name   | app               |
| ---------- | ---------- | ----------------- |
| postgres   | postgres   | cnpg-operator     |
| talos      | talos      | talos-backup      |
| volsync    | volsync    | volsync           |

#### Minio

- minio-app on truenas-scale;
- init via terraform modules, reset via taskfile;

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

### NFS

- use truenas-scale as main nas;
- endpoint: `nas.homelab.internal`;
- shares: `/mnt/Arcanum/shared/media`;
- permissions: `uid:gid=2000:2000`;
- folders: `data` and `comic,ebook,manga,movie,music,photo,tvshow`;
