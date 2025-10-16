# Media Apps

- This namespace manages NFS-based applications;
- backed by `csi-driver-nfs` PVC, supported by NAS;
- NFS path = `/shared-path/${pvc.metadata.name}`;
- volume, maproot/owner = `2000:2000`;

## Media stack

- [moviepilot](https://movie-pilot.org/), need pt accounts; not used but active;
- starrs, need usenet subscriptions; not used;
- usd/yr => emby-4k-subs(100) > usenet(130 1st year, 50 later) >= pt-4k-subs(50) > xiaoya(nearly free);
