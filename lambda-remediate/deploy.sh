#!/bin/bash
set -e
cd ~/lab-floci-terraform

# Instala boto3 no host se não tiver
pip3 install boto3 -q

# Cria bucket se não existe
aws --endpoint-url=http://localhost:4566 s3api create-bucket --bucket soc-evidence 2>/dev/null || true

# Zipa lambda
cd lambda-remediate
zip -r lambda.zip lambda_function.py > /dev/null
cd..

# Cria lambda no LocalStack
aws --endpoint-url=http://localhost:4566 lambda create-function \
  --function-name soc-auto-remediate \
  --runtime python3.9 \
  --role arn:aws:iam::000000000000:role/lambda-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://lambda-remediate/lambda.zip 2>/dev/null || \
aws --endpoint-url=http://localhost:4566 lambda update-function-code \
  --function-name soc-auto-remediate \
  --zip-file fileb://lambda-remediate/lambda.zip

echo "--- Lambda criada ---"
aws --endpoint-url=http://localhost:4566 lambda list-functions | grep soc-auto

# Cria trigger S3 -> Lambda
aws --endpoint-url=http://localhost:4566 s3api put-bucket-notification-configuration \
  --bucket soc-evidence \
  --notification-configuration '{
    "LambdaFunctionConfigurations": [{
      "LambdaFunctionArn": "arn:aws:lambda:us-east-1:000000000000:function:soc-auto-remediate",
      "Events": ["s3:ObjectCreated:*"],
      "Filter": {"Key": {"FilterRules": [{"Name": "prefix", "Value": "alerts/"}]}}
    }]
  }'

echo "[+] Trigger configurado"
