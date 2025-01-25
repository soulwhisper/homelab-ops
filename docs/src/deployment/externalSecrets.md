## Externalsecret

### 1Password

- 1password compatible items: secret, document;
- in this repo, all password use `secret` item;
- encryption_ciper => `openssl rand -base64 36`;

| remoteRef.key  | remoteRef.property | remoteRef.value       | ignored                     |
| -------------- | ------------------ | --------------------- | --------------------------- |
| password.title | password.label     | password.new_field    | password.section/notes/tags |
| document.title | document.file_name | document.file_content | document.section/notes/tags |

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
