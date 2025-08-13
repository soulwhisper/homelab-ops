## NFS Archied

- endpoint: `nas.homelab.internal`;
- shares: `/mnt/Arcanum/Media`;
- permissions: `uid:gid=2000:2000, rwx, all_squash`; truenas: `MapRoot`;
- folders: `model` and `Downloads,comic,ebook,manga,movie,music,photo,tvshow`;

> NFS-mounts

- since kubernetes version 1.33, `UserNamespaces` becomes default true, nfs mounts have `idmap` issues, [ref](https://kubernetes.io/blog/2025/04/25/userns-enabled-by-default/);
- csi-driver-nfs slow mount issue fixed, [ref](https://github.com/kubernetes-csi/csi-driver-nfs/issues/870);
- so nfs mounts revert to `csi-driver-nfs`;

> NFS-connections

- nfs network status can be monitored via `blackbox-exporter` or kubelet `labels:mountpoint` with `featureGate:CSIVolumeHealth`;

> NFS-snapshots

- previously, using nfs as snapshots destination;
- check `components` for details;

> NFS-monitoring

- monitor nas-status and nfs-mount via `victora-metrics`, `blackbox-exporter` and `keda`;
- silence not-needed alerts via `silence-operator`;
- scheduled nas powerdown scaling supported via `keda`;
