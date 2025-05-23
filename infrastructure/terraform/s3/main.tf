terraform {
  required_providers {
    minio = {
      source = "aminueza/terraform-provider-minio"
      version = ">= 3.0.0"
    }
    onepassword = {
      source = "1Password/onepassword"
      version = "~> 2.1.0"
    }
  }
}
