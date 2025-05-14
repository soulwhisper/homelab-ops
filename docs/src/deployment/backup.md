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

- endpoint = `http://s3.noirprime.com:9000`
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
