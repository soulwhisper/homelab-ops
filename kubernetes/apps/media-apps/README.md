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
