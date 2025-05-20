## Usage

> external

```shell
# ks.yaml
  components:
    - ../../../../components/gatus/external
  postBuild:
    substitute:
      APP: flux-webhook
      GATUS_STATUS: '404'
```

> internal

```shell
  components:
    - ../../../../components/gatus/internal
  postBuild:
    substitute:
      APP: rook
```
