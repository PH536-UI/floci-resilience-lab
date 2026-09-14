# SQS Principal
resource "aws_sqs_queue" "guardiao_queue" {
  name = "guardiao-queue-ph"
}

# DynamoDB - mantem hash id igual ao existente
resource "aws_dynamodb_table" "guardiao_state" {
  name         = "guardiao-state-ph"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
}

# IAM
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

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_extra" {
  name = "guardiao-extra-ph"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:PutItem", "dynamodb:GetItem", "dynamodb:Scan"]
        Resource = "*"
      }
    ]
  })
}

# Lambda - mantem nome igual ao existente
resource "aws_lambda_function" "guardiao_lambda" {
  function_name = "guardiao-processor-ph"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"
  filename      = "lambda.zip"
  timeout       = 30
  environment {
    variables = {
      TABLE_NAME       = "guardiao-state-ph"
      AWS_ENDPOINT_URL = "http://172.17.0.2:4566"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_lambda" {
  event_source_arn = aws_sqs_queue.guardiao_queue.arn
  function_name    = aws_lambda_function.guardiao_lambda.arn
  batch_size       = 10
}

# NIVEL 4: DLQ + V2
resource "aws_sqs_queue" "guardiao_dlq" {
  name = "guardiao-dlq-ph"
}

resource "aws_sqs_queue" "guardiao_queue_v2" {
  name = "guardiao-queue-ph-v2"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.guardiao_dlq.arn
    maxReceiveCount     = 3
  })
}
