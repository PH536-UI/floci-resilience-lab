# SPEC - Próxima Feature

## Objetivo
Criar S3 bucket guardiao-ph-terraform-state para guardar tfstate remoto

## Requisitos
- Nome: ph-terraform-state-536 (único)
- Versionamento: Enabled
- Criptografia: AES256
- Bloquear acesso público: ON
- Tags: Project=Guardião, Owner=PH

## Critérios de Aceite
1. `terraform apply` sem erro
2. `aws s3 ls | grep ph-terraform-state` retorna bucket
3. `rclone about gdrive:` continua < 12GB

## Limites
- Não usar DynamoDB (custo)
- Região fixa sa-east-1
