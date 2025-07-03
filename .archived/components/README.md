## Volsync

- This is a method to backup snapshots to NFS;

### Components

- `cnpg:cronjob`
- `volsync:nfs`

### MutatingAdmissionPolicy

- `kubernetes/apps/storage-system/volsync/app/policy`
- `talconfig.yaml`

```yaml
# controlPlane only patches
patches:
  # : ApiServer configuration
  # :: Enable MutatingAdmissionPolicy;
  - |-
    cluster:
      apiServer:
        extraArgs:
          runtime-config: admissionregistration.k8s.io/v1alpha1=true
          feature-gates: MutatingAdmissionPolicy=true
```
