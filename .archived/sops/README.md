## SOPS

- replaced globally by onepassword, then by evsubst for non-secret ecryption;
- more [ref](https://github.com/ahgraber/homelab-gitops-k3s/tree/main/kubernetes/flux);

> evsubst

```yaml
spec:
  postBuild:
    substituteFrom:
      - kind: ConfigMap
        name: cluster-settings
      - kind: Secret
        name: cluster-secrets
```

## Old ways

> flux-instace:values.yaml

```yaml
---
instance:
  kustomize:
    patches:
      # Add Sops decryption to Kustomizations
      - patch: |
          - op: add
            path: /spec/decryption
            value:
              provider: sops
              secretRef:
                name: sops-age
        target:
          group: kustomize.toolkit.fluxcd.io
          kind: Kustomization
```

> flux/cluster/ks.yaml

```yaml
spec:
  decryption:
    provider: sops
    secretRef:
      name: sops-age
```

> bootstrap/resource.yaml.j2

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: gitops-system
---
apiVersion: v1
kind: Secret
metadata:
  name: sops-age
  namespace: gitops-system
stringData:
  age.agekey: |
    {{ ENV.FLUX_SOPS_PRIVATE_KEY | indent(4) }}
```

> bootstrap/bootstrap.env

```shell
FLUX_SOPS_PRIVATE_KEY=op://DevOps/age-keys/user_flux_private
```

> others

```shell
## .gitattributes
*.sops.* diff=sopsdiffer

## .gitignore
.decrypted~*
```
