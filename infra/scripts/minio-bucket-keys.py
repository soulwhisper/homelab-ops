import asyncio
import subprocess
import json
import os

from onepassword import *

# Usage
# 1, install onepassword-sdk and minio-client, change {minio_cli} according to package
# pacman -Sy minio-client
# pip install onepassword-sdk
# 2, export envs
# export MINIO_ENDPOINT=""
# export MINIO_USER=""
# export MINIO_PASSWORD=""
# export OP_VAULT=""
# export OP_ITEM=""
# export OP_SERVICE_ACCOUNT_TOKEN=""
# 3, run script

# set envs
app_names = ["loki", "volsync", "crunchy-postgres"]
minio_cli = "mcli"
minio_endpoint = os.getenv("MINIO_ENDPOINT")
minio_user = os.getenv("MINIO_USER")
minio_password = os.getenv("MINIO_PASSWORD")
op_vault = os.getenv("OP_VAULT")
op_item = os.getenv("OP_ITEM")
op_token = os.getenv("OP_SERVICE_ACCOUNT_TOKEN")

# verify envs
if not minio_endpoint:
    raise EnvironmentError("env.MINIO_ENDPOINT must be set.")
if not minio_user:
    raise EnvironmentError("env.MINIO_USER must be set.")
if not minio_password:
    raise EnvironmentError("env.MINIO_PASSWORD must be set.")
if not op_vault:
    raise EnvironmentError("env.OP_VAULT must be set.")
if not op_item:
    raise EnvironmentError("env.OP_ITEM must be set.")
if not op_token:
    raise EnvironmentError("env.OP_SERVICE_ACCOUNT_TOKEN must be set.")

def cleanup():
    for app_name in app_names:
        os.remove(f"{app_name}_policy.json")

async def main():
    # minio auth
    subprocess.run([minio_cli, "alias", "set", "minio", minio_endpoint, minio_user, minio_password], check=True)

    # 1password auth
    op_client = await Client.authenticate(
        auth=op_token,
        integration_name="1password",
        integration_version="v1.0.0",
    )

    # main
    for app_name in app_names:
        op_app_name = app_name.replace('-', '_')
        access_key = await op_client.secrets.resolve(f"op://{op_vault}/{op_item}/{op_app_name}_access_key")
        secret_key = await op_client.secrets.resolve(f"op://{op_vault}/{op_item}/{op_app_name}_secret_key")

        # create policy JSON
        policy = {
            "Version": "",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": ["s3:*"],
                    "Resource": [
                        f"arn:aws:s3:::{app_name}",
                        f"arn:aws:s3:::{app_name}/*"
                    ]
                }
            ]
        }

        await asyncio.to_thread(json.dump, policy, open(f"{app_name}_policy.json", 'w'))

        # create bucket
        subprocess.run([
            minio_cli, "mb",
            f"minio/{app_name}",
            "--ignore-existing"
            ], check=True)

        # import access key and policy
        subprocess.run([
            minio_cli, "admin", "user", "svcacct", "add",
            "--access-key", access_key,
            "--secret-key", secret_key,
            "--policy", f"{app_name}_policy.json",
            "--name", app_name,
            "minio", minio_user
            ], check=True)

        print(f"{app_name} bucket created and configured.")

if __name__ == '__main__':
    asyncio.run(main())
    cleanup()
