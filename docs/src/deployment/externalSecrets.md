# Externalsecret

## 1Password

- 1password compatible items: secret, document;
- in this repo, all password use `secret` item;
- encryption_ciper => `openssl rand -base64 36`;
- 1password-sync might need https_proxy;

| remoteRef.key  | remoteRef.property | remoteRef.value       | ignored                     |
| -------------- | ------------------ | --------------------- | --------------------------- |
| password.title | password.label     | password.new_field    | password.section/notes/tags |
| document.title | document.file_name | document.file_content | document.section/notes/tags |

### Naming

- externalSecret and Secret name should be same
- secrets refers to app itself, use `appname`
- secrets refers to using other services, use `appname`-`service`-`usage`

### Example

```yaml
---
# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/externalsecret_v1.json
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: cnpg
spec:
  refreshInterval: 30m
  secretStoreRef:
    kind: ClusterSecretStore
    name: onepassword
  target:
    template:
      data:
        username: "{{ .admin_user }}"
        password: "{{ .admin_pass }}"
        aws-access-key-id: "{{ .postgres_access_key }}"
        aws-secret-access-key: "{{ .postgres_secret_key }}"
  dataFrom:
    - extract:
        key: app_user
    - extract:
        key: minio
```
