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
- secrets refers to app itself, use appname
- secrets refers to using other services, use `appname`-`service`-`usage`

### Example

```yaml
---
# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/externalsecret_v1.json
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: paperless
spec:
  refreshInterval: 5m
  secretStoreRef:
    kind: ClusterSecretStore
    name: onepassword
  target:
    name: paperless
    creationPolicy: Owner
    template:
      data:
        PAPERLESS_ADMIN_USER: "{{ .paperless_username }}"
        PAPERLESS_ADMIN_PASSWORD: "{{ .paperless_password }}"
        PAPERLESS_SECRET_KEY: "{{ .paperless_encryption_cipher }}"
  data:
    - secretKey: paperless_username
      remoteRef:
        key: app_admin
        property: admin_user
    - secretKey: paperless_password
      remoteRef:
        key: app_admin
        property: admin_pass
    - secretKey: paperless_encryption_cipher
      remoteRef:
        key: encryption_cipher
        property: paperless
```
