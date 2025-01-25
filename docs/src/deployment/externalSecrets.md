## Externalsecret

### 1Password

- 1password compatible items: secret, document;
- in this repo, all password use `secret` item;
- encryption_ciper => `openssl rand -base64 36`;

| remoteRef.key  | remoteRef.property | remoteRef.value       | ignored                     |
| -------------- | ------------------ | --------------------- | --------------------------- |
| password.title | password.label     | password.new_field    | password.section/notes/tags |
| document.title | document.file_name | document.file_content | document.section/notes/tags |

```yaml
---
# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/externalsecret_v1beta1.json
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: paperless
spec:
  refreshInterval: 5m
  secretStoreRef:
    kind: ClusterSecretStore
    name: onepassword
  target:
    name: paperless-secret
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
        property: username
    - secretKey: paperless_password
      remoteRef:
        key: app_admin
        property: password
    - secretKey: paperless_encryption_cipher
      remoteRef:
        key: encryption_cipher
        property: paperless
```

### S3 Storage

| app              | bucket           | key-name         |
| ---------------- | ---------------- | ---------------- |
| crunchy-postgres | crunchy-postgres | crunchy-postgres |
| volsync          | volsync          | volsync          |

#### Cloudflare

- cloudflared-tunnel => zero-trust / networks / tunnels => ingress-ext, ingress-ext.noirprime.com
- cloudflare, dns-01, noirprime.com: user-profile =>api-tokens, ZONE:READ / DNS:EDIT
- CLUSTER_SECRET_CPGO_R2_ENDPOINT = https://${CF_ACCOUNT_TAG}.r2.cloudflarestorage.com

#### Minio

- endpoint = `https://s3.noirprime.com`
- region = us-east-1
- versioning = disabled; object-locking = disabled; quota = disabled;

```json
{
  "Version": "",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": ["arn:aws:s3:::volsync/*", "arn:aws:s3:::volsync"]
    }
  ]
}
```
