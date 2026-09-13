# Projeto Guardiao

Pipeline serverless SQS -> Lambda -> DynamoDB, testado em ambiente LocalStack (Floci) e compativel com AWS real (sa-east-1).

## Arquitetura
- SQS: fila guardiao-queue-ph recebe mensagens
- Lambda: guardiao-processor-ph processa e persiste
- DynamoDB: guardiao-state-ph armazena estado
- S3: bucket versionado com SSE para state do Terraform

## Stack
Terraform - Python 3.11 - boto3 - AWS SQS/Lambda/DynamoDB/S3

## Evidencia de Deploy
Ver guardiao-evidencia.txt para output completo do terraform state list, scan do DynamoDB, e listagens de S3/SQS.

## Known Issues
Ver secao "Known Issues (Atualizado)" no CLAUDE.md - timeout Lambda->DynamoDB resolvido, causa raiz documentada.
