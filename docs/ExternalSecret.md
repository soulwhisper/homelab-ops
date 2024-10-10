# Externalsecret

## 1Password-api

- 1password compatible items: secret, document
- in-built field labeled 'password' in password type items is preferred

| remoteRef.key  | remoteRef.property | remoteRef.value       | ignored                     |
| -------------- | ------------------ | --------------------- | --------------------------- |
| password.title | password.label     | password.new_field    | password.section/notes/tags |
| document.title | document.file_name | document.file_content | document.section/notes/tags |

### Cloudflare

* cloudflared-tunnel => zero-trust / networks / tunnels => homelab-ingress-ext; ingress-ext.noirprime.com, http://localhost:8080
* cloudflare, dns-01, noirprime.com: user-profile =>api-tokens, ZONE:READ / DNS:EDIT
* CLUSTER_SECRET_CPGO_R2_ENDPOINT = https://${CF_ACCOUNT_TAG}.r2.cloudflarestorage.com

### Minio

- endpoint = `https://s3.noirprime.com`
- region = us-east-1
- versioning = disabled; object-locking = disabled; quota = disabled;

```
# access-key-policy-rw-example
{
 "Version": "",
 "Statement": [
  {
   "Effect": "Allow",
   "Action": [
    "s3:*"
   ],
   "Resource": [
    "arn:aws:s3:::volsync/*",
    "arn:aws:s3:::volsync"
   ]
  }
 ]
}
```

| app              | bucket           | key-name         |
| ---------------- | ---------------- | ---------------- |
| crunchy-postgres | crunchy-postgres | crunchy-postgres |
| volsync          | volsync          | volsync          |
| loki             | loki             | loki             |

## Passwords

- backup_encryption_ciper => `openssl rand -base64 48`

| Type     | Key              | Property                    |
| -------- | ---------------- | --------------------------- |
| password | cloudflare       | account_tag                 |
|          |                  | api_token                   |
|          |                  | tunnel_id                   |
|          |                  | tunnel_token                |
|          |                  | crunchy_postgres_access_key |
|          |                  | crunchy_postgres_secret_key |
|          |                  | volsync_access_key          |
|          |                  | volsync_secret_key          |
| password | minio            | username                    |
|          |                  | password                    |
|          |                  | crunchy_postgres_access_key |
|          |                  | crunchy_postgres_secret_key |
|          |                  | volsync_access_key          |
|          |                  | volsync_secret_key          |
|          |                  | loki_access_key             |
|          |                  | loki_secret_key             |
| password | paperless        | username                    |
|          |                  | password                    |
|          |                  | encryption_cipher           |
| password | crunchy-postgres | encryption_cipher           |
| password | volsync          | encryption_cipher           |
| password | grafana          | username                    |
|          |                  | password                    |
