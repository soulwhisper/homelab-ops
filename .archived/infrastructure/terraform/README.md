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

### Minio issues

- Minio removed all UI features but the object browser after [this-PR](https://github.com/minio/object-browser/pull/3509#event-17821738077) / ui-v2.0.0 / minio-RELEASE.2025-05-24T17-08-30Z;
- community fork check [ref](https://github.com/OpenMaxIO/openmaxio-object-browser);
- `mc` cli server still function;
- truenas-app pin `1.2.x`;

> Versity S3 Gateway

- Multi-backend s3 gateway, better for truenas ZFS;
- also disable accounts in single tenant mode for simplicity;

```shell
docker run --name versitygw --user 2000:2000 \
  -p 7070:7070 \
  -v /root/vgw/data:/tmp/vgw \
  -e ROOT_ACCESS_KEY=admin \
  -e ROOT_SECRET_KEY=adminadmin \
  -d ghcr.io/versity/versitygw:latest posix /tmp/vgw
```
