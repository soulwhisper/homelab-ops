## Usage

- depreacted since using onepassword as external-secrets

```shell
# resources.yaml.j2
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

# bootstrap.env
FLUX_SOPS_PRIVATE_KEY=op://DevOps/age-keys/user_flux_private

# gitops-system/flux-operator/instace/values.yaml
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

# flux/cluster/cluster.yaml
spec:
  decryption:
    provider: sops
    secretRef:
      name: sops-age
# gitops-system/kustomization.yaml
components:
  - ../../components/sops
```
