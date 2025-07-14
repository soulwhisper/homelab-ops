# Media Apps

- This namespace manages media applications
- backed by nfs-volume `shared-media` on TrueNAS
- use `keda` to reduce nas mount noise, if nas schedule offline;

```yaml
# ks.yaml
spec:
  dependsOn:
    - name: keda
      namespace: kube-system
  components:
    - ../../../../components/keda/nas-nfs-scaler
  postBuild:
    substitute:
      APP: *appname
```

## Media stack choice

- [docker-xiaoya](https://github.com/monlor/docker-xiaoya), need aliyun/115/pikpak accounts; not used but active;
- [moviepilot](https://movie-pilot.org/), need pt accounts; not used but active;
- starrs, need usenet subscriptions; not used;
- usd/yr => emby-4k-subs(100) > usenet(130 1st year, 50 later) >= pt-4k-subs(50) > xiaoya(nearly free);
