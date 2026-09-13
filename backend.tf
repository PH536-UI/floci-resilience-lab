terraform {
  backend "s3" {
    bucket = "ph-terraform-state-536"
    key    = "lab-floci-terraform/terraform.tfstate"
    region = "sa-east-1"
    # Floci local
    access_key = "test"
    secret_key = "test"
    endpoints = {
      s3 = "http://localhost:4566"
    }
    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
