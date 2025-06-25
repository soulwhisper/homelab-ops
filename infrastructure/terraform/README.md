# Terraform

## S3

- boostrap minio for backups， ref:[Backup.md](https://github.com/soulwhisper/homelab-ops/blob/main/docs/src/deployment/backup.md);
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
