## Externalsecret

### 1Password

- 1password compatible items: secret, document;
- in this repo, all passwords use `secret` item;
- encryption*ciper => `openssl rand -base64 50 | tr '+/' '-*' | tr -d '=' | head -c 50`;
- 1password-sync need https_proxy;

| remoteRef.key  | remoteRef.property | remoteRef.value       | ignored                     |
| -------------- | ------------------ | --------------------- | --------------------------- |
| password.title | password.label     | password.new_field    | password.section/notes/tags |
| document.title | document.file_name | document.file_content | document.section/notes/tags |

#### Naming

- externalSecret and Secret name should be same
- secrets refers to app itself, use `appname`
- secrets refers to using other services, use `appname`-`service`-`usage`

#### Example

```yaml
---
# yaml-language-server: $schema=https://kubernetes-schemas.noirprime.com/external-secrets.io/externalsecret_v1.json
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: example-app
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
  dataFrom:
    - extract:
        key: app_user
```
