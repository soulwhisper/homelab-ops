## SOPS

- replaced globally by onepassword, then by evsubst for non-secret ecryption;
- more [ref](https://github.com/ahgraber/homelab-gitops-k3s/tree/main/kubernetes/flux);

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
