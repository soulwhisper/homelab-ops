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

## Moviepilot

- bt auto lib
  `curl "http://moviepilot:3000/api/v1/transfer/now?token=moviepilot"`
- admin password
  `kubectl logs -n media-apps moviepilot | grep "超级管理员初始密码"`
- notify via webPush, [ref](https://wiki.movie-pilot.org/zh/notification)
