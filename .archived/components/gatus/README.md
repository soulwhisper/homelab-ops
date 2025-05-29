## Usage

- to make sure services online and reachable;
- deprecated;

> external

```shell
# ks.yaml
spec:
  components:
    - ../../../../components/gatus/external
  postBuild:
    substitute:
      APP: *appname
      GATUS_SUBDOMAIN: auth  # default:appname or specified

# special
- authelia -> GATUS_SUBDOMAIN:auth
- flux-instance -> APP:flux-webhook, GATUS_STATUS:'404'
- immich -> GATUS_SUBDOMAIN:photo
- kromgo -> GATUS_STATUS:'404'
```

> internal

```shell
# ks.yaml
spec:
  components:
    - ../../../../components/gatus/external
  postBuild:
    substitute:
      APP: *appname

# special
- rook-ceph-cluster -> APP:rook
```
