provider "minio" {
  alias  = "nas"
  minio_server   = module.onepassword_item_minio.fields.server
  minio_user     = module.onepassword_item_minio.fields.username
  minio_password = module.onepassword_item_minio.fields.password
  minio_ssl      = false
}
