variable "bucket_name" {
  type = string
}

variable "is_public" {
  type = bool
  default = false
}

variable "bucket_access_key" {
  type      = string
  sensitive = false
  default   = null
}

variable "bucket_secret_key" {
  type      = string
  sensitive = true
  default   = null
}
