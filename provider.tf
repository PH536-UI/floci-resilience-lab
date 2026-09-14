variable "is_local" {
  type    = bool
  default = true
}

provider "aws" {
  region                      = "sa-east-1"
  access_key                  = var.is_local ? "test" : null
  secret_key                  = var.is_local ? "test" : null
  skip_credentials_validation = var.is_local
  skip_requesting_account_id  = var.is_local
  skip_metadata_api_check     = var.is_local
  s3_use_path_style           = var.is_local

  endpoints {
    apigateway = var.is_local ? "http://localhost:4566" : null
    s3         = var.is_local ? "http://localhost:4566" : null
    sqs        = var.is_local ? "http://localhost:4566" : null
    dynamodb   = var.is_local ? "http://localhost:4566" : null
    lambda     = var.is_local ? "http://localhost:4566" : null
    iam        = var.is_local ? "http://localhost:4566" : null
  }
}
