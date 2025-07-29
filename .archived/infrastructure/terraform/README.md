# Terraform

## S3

- boostrap minio for backups;
- for each bucket, use keyPair to create a user, then create and attach its RW policy;
- Attention! if minio has unmanaged same buckets/keys, boostrap will fail;

```shell
# s3
export OP_SERVICE_ACCOUNT_TOKEN=

terrafrom init
terraform apply
```

### Buckets

- current, only `postgres` and `volsync` is needed;

## Minio issues

- Minio removed all UI features but the object browser since [this-PR](https://github.com/minio/object-browser/pull/3509#event-17821738077) / ui-v2.0.0 / minio-RELEASE.2025-05-24T17-08-30Z;
- community UI fork check [ref](https://github.com/OpenMaxIO/openmaxio-object-browser);
- `mc` cli server still function;
- truenas-app should pin `1.2.x`;

### Replacements

- IAM is not a must;
- lifecycle config is not needed;

> Versity S3 Gateway

- multi-backend s3 gateway, optimized for ZFS/XFS;
- disable IAM in single tenant mode for simplicity;
- can run as systemd service;
- Best for NAS;

```shell
# deployment
docker run --name versitygw --user 2000:2000 \
  -p 7070:7070/tcp \
  -v /root/vgw/data:/tmp/vgw \
  -e ROOT_ACCESS_KEY=admin \
  -e ROOT_SECRET_KEY=adminadmin \
  -d ghcr.io/versity/versitygw:latest posix /tmp/vgw

# boostrap
mc alias set vgw http://127.0.0.1:7070 "$ROOT_ACCESS_KEY" "$ROOT_SECRET_KEY"
mc mb vgw/postgres
```

> Garage

- simple objectstore service, multi-node design, can host static websites;
- use bucket/key instead of policies;
- support `AbortIncompleteMultipartUpload` and `Expiration` (without `ExpiredObjectDeleteMarker`) lifecycle config;
- can run as systemd service;
- have helm chart;
- Best for K8S/Other;

```shell
# deployment
docker run --name garage \
  -p 3900:3900/tcp -p 3901:3901/tcp \
  -v /etc/garage.toml:/etc/garage.toml \
  -v /var/lib/garage/meta:/var/lib/garage/meta \
  -v /var/lib/garage/data:/var/lib/garage/data \
  -d dxflrs/garage:v2.0.0

# bootstrap
garage bucket create postgres
garage key import "$access_key" "$secret_key"
garage bucket allow --read --write --owner postgres --key "$access_key"
```
