## Storage

### Block

- Internal, `ceph-block` with rep3 for apps;
- reduce ceph complexity to avoid too many PGs;

### ObjectStore

- External, versitygw for snapshots;

| bucket   | app           |
| -------- | ------------- |
| postgres | cnpg-operator |
| volsync  | volsync       |

### NFS

- External, via `csi-driver-nfs` for media-apps;
- endpoint: `nas.homelab.internal`;
- permissions: `uid:gid=2000:2000, rwx, all_squash`; truenas: `MapRoot`;
