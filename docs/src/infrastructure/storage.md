## Storage

### Block

- Internal, `ceph-block` with rep3 for apps;
- reduce ceph complexity to avoid too many PGs;

### ObjectStore

- External, versitygw for snapshots;

| bucket   | app         |
| -------- | ----------- |
| postgres | cnpg-barman |
| volsync  | volsync     |

### NFS

- External, via `csi-driver-nfs` for media-apps;
- endpoint: `nas.homelab.internal`;
- permissions: `uid:gid=2000:2000, rwx, all_squash`; truenas: `MapRoot`;

#### Folders

- `media`, general media files;
- `media/TVShows`, TV shows;
- `media/Photos`, photos;
- `media/Music`, music files;
- `media/Documents`, ebook files;
- `media/Playlists/LMS`, lms playlists;
- `media/Downloads/qbittorrent`, bt files;
- `models/3D`, fdm printer models;
- `models/LLM`, llm models;
- `storage`, cloud files;
- `trpg/FoundryVTT`, trpg world files;
