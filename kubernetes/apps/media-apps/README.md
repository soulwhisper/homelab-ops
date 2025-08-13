# Media Apps

- This namespace manages media applications
- backed by `shared-media` PVC, previously NAS, now CephFS
- volume, maproot/owner = `2000:2000`

## Media stack choice

- [docker-xiaoya](https://github.com/monlor/docker-xiaoya), need aliyun/115/pikpak accounts; not used but active;
- [moviepilot](https://movie-pilot.org/), need pt accounts; not used but active;
- starrs, need usenet subscriptions; not used;
- usd/yr => emby-4k-subs(100) > usenet(130 1st year, 50 later) >= pt-4k-subs(50) > xiaoya(nearly free);
