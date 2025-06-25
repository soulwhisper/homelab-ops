## Usage

- to make sure services online and reachable;

> external

```shell
# ks.yaml
spec:
  components:
    - ../../../../components/gatus/external
  postBuild:
    substitute:
      APP: *appname
      GATUS_SUBDOMAIN: flux-webhook  # default:appname or specified

# list
- APP:echo
- APP:flux-instance, GATUS_SUBDOMAIN: flux-webhook, GATUS_STATUS:'404'
- APP:kromgo, GATUS_STATUS:'404'
- APP:n8n, GATUS_SUBDOMAIN: n8n-webhook, GATUS_STATUS:'404'
```

> internal

```shell
# ks.yaml
spec:
  components:
    - ../../../../components/gatus/internal
  postBuild:
    substitute:
      APP: *appname
      GATUS_SUBDOMAIN: auth  # default:appname or specified

```
