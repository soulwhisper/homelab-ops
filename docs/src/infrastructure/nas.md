# NAS

- Migrated from Nix-NAS to TrueNAS Scale

## NFS

- host: nas.homelab.internal
- permission: 2000:2000

> k8s-backup (not-used)
> path: /mnt/Arcanum/k8s

- folder: talos,postgres

> shared-media
> path: /mnt/Arcanum/shared/media

- folder: comic,data,ebook,manga,movie,music,photo,tvshow

## APP:Minio

> bucket

- draonfly
- postgres
- talos
- volsync

> policy

```json
{
 "Version": "",
 "Statement": [
  {
   "Effect": "Allow",
   "Action": [
    "s3:*"
   ],
   "Resource": [
    "arn:aws:s3:::${bucket}",
    "arn:aws:s3:::${bucket}/*"
   ]
  }
 ]
}
```
