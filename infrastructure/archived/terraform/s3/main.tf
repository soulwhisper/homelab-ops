terraform {
  required_providers {
    minio = {
      source = "aminueza/minio"
      version = ">= 3.0.0"
    }
    onepassword = {
      source = "1Password/onepassword"
      version = "~> 2.2.0"
    }
  }
}
