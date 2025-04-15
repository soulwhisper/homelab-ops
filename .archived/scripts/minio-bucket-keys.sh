#!/bin/bash

# Usage:
# 1, install the required tools: minio-client and 1password-cli (op)
#    sudo pacman -Sy minio-client
#    pip install onepassword-sdk
# 2, set the following environment variables:
#    export MINIO_ENDPOINT=""
#    export MINIO_USER=""
#    export MINIO_PASSWORD=""
#    export OP_VAULT=""
#    export OP_ITEM=""
#    export OP_SERVICE_ACCOUNT_TOKEN=""
# 3, run this script.

# Check if required environment variables are set
if [ -z "$MINIO_ENDPOINT" ]; then
  echo "Error: MINIO_ENDPOINT must be set."
  exit 1
fi

if [ -z "$MINIO_USER" ]; then
  echo "Error: MINIO_USER must be set."
  exit 1
fi

if [ -z "$MINIO_PASSWORD" ]; then
  echo "Error: MINIO_PASSWORD must be set."
  exit 1
fi

if [ -z "$OP_VAULT" ]; then
  echo "Error: OP_VAULT must be set."
  exit 1
fi

if [ -z "$OP_ITEM" ]; then
  echo "Error: OP_ITEM must be set."
  exit 1
fi

if [ -z "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
  echo "Error: OP_SERVICE_ACCOUNT_TOKEN must be set."
  exit 1
fi

# Set application names
app_names=("loki" "volsync" "crunchy-postgres")
minio_cli="mcli"

# MinIO auth (setting MinIO endpoint alias)
$minio_cli alias set minio "$MINIO_ENDPOINT" "$MINIO_USER" "$MINIO_PASSWORD"

# 1Password auth (authenticate using service account token)
op_authentication=$(op signin --token "$OP_SERVICE_ACCOUNT_TOKEN" --no-browser)

# Function to clean up generated policy files
cleanup() {
  for app_name in "${app_names[@]}"; do
    rm -f "${app_name}_policy.json"
  done
}

# Main logic for bucket creation and policy assignment
for app_name in "${app_names[@]}"; do
  op_app_name=$(echo "$app_name" | sed 's/-/_/g')

  # Retrieve access and secret keys from 1Password
  access_key=$(op read "op://$OP_VAULT/$OP_ITEM/$op_app_name_access_key")
  secret_key=$(op read "op://$OP_VAULT/$OP_ITEM/$op_app_name_secret_key")

  # Create policy JSON
  cat <<EOF > "${app_name}_policy.json"
{
  "Version": "",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": [
        "arn:aws:s3:::${app_name}",
        "arn:aws:s3:::${app_name}/*"
      ]
    }
  ]
}
EOF

  # Create MinIO bucket (ignore if it already exists)
  $minio_cli mb "minio/$app_name" --ignore-existing

  # Create MinIO user and assign policy
  $minio_cli admin user svcacct add \
    --access-key "$access_key" \
    --secret-key "$secret_key" \
    --policy "${app_name}_policy.json" \
    --name "$app_name" \
    minio "$MINIO_USER"

  echo "$app_name bucket created and configured."
done

# Cleanup generated policy files
cleanup
