provider "aws" {
  region                      = "sa-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true
  endpoints {
    s3       = "http://localhost:4566"
    sts      = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    iam      = "http://localhost:4566"
    sqs      = "http://localhost:4566"
    lambda   = "http://localhost:4566"
  }
  default_tags {
    tags = { Project = "Guardião", Owner = "PH" }
  }
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "ph-terraform-state-536"
}
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_dynamodb_table" "guardiao_state" {
  name         = "guardiao-state-ph"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
}
resource "aws_iam_role" "lambda_role" {
  name = "guardiao-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}
resource "aws_sqs_queue" "guardiao_queue" {
  name = "guardiao-queue-ph"
}
resource "aws_lambda_function" "guardiao_lambda" {
  function_name = "guardiao-processor-ph"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"
  filename      = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
  timeout       = 30
  environment {
    variables = {
      TABLE_NAME       = aws_dynamodb_table.guardiao_state.name
      AWS_ENDPOINT_URL = "http://172.17.0.2:4566"
    }
  }
}
resource "aws_lambda_event_source_mapping" "sqs_lambda" {
  event_source_arn = aws_sqs_queue.guardiao_queue.arn
  function_name    = aws_lambda_function.guardiao_lambda.arn
}
