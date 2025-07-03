## Backups

- previously, using out-of-cluster s3 for snapshots;
- following `3-2-1` strategy, using in-cluster `ceph-bucket` for snapshots, `rsync-on-nas` and `rsync-to-dropbox` for backups;
- media files on `TrueNAS Scale`;

> ObjectStore

| bucket   | key-name | app           |
| -------- | -------- | ------------- |
| postgres | postgres | cnpg-operator |
| volsync  | volsync  | volsync       |

> NFS

- endpoint: `nas.homelab.internal`;
- shares: `/mnt/Arcanum/shared/media`;
- permissions: `uid:gid=2000:2000`;
- folders: `model` and `Downloads,comic,ebook,manga,movie,music,photo,tvshow`;

### NFS-snapshots

- previously, using nfs as snapshots destination;
- check `.archived/components` for details;
