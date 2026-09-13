# Guardiao - Floci Resilience Lab - Nivel 3 Concluido

Repo: https://github.com/PH536-UI/floci-resilience-lab
Commit validacao: f844f77 - 8/8 recursos + ph-007

## Arquitetura Nivel 3
SQS guardiao-queue-ph -> Lambda guardiao-processor-ph -> DynamoDB guardiao-state-ph
S3 ph-terraform-state-536 (backend + versioning + AES256)
IAM + CloudWatch

## Evidencia Final 13/09/2026
terraform state list 8/8:
- aws_dynamodb_table.guardiao_state
- aws_iam_role.lambda_role
- aws_lambda_event_source_mapping.sqs_lambda
- aws_lambda_function.guardiao_lambda
- aws_s3_bucket.terraform_state
- aws_s3_bucket_server_side_encryption_configuration.state
- aws_s3_bucket_versioning.state
- aws_sqs_queue.guardiao_queue

SQS list-queues: guardiao-queue-ph OK
DynamoDB scan: ph-007 OK

Arquivo: EVIDENCIA_N3.txt

## Bugs Resolvidos
Bug1 Lambda timeout: source_code_hash faltando + host.docker.internal NAT quebrado -> fix IP 172.17.0.2
Bug2 Floci reset apaga S3 -> fix terraform import + region sa-east-1 obrigatorio

## Reproduzir
floci start
aws --endpoint-url=http://localhost:4566 s3 mb s3://ph-terraform-state-536
terraform init -reconfigure
terraform apply -auto-approve
