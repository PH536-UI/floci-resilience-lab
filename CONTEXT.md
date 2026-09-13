# CONTEXT - lab-floci-terraform | PH

## Ambiente
- Projeto: Guardião Backup + Labs AWS
- Região: sa-east-1 (São Paulo)
- Owner: PH | Tags obrigatórias: Project=Guardião, Owner=PH
- Orçamento: < $5/mês

## Stack
AWS S3, EC2, IAM, Terraform, rclone, gdrive
Estado: terraform.tfstate local + backup no gdrive:00-BACKUPS-GUARDIAO/

## Padrões (a IA DEVE seguir)
- Nomenclatura: ph-*, guardiao-*
- Nunca expor secrets no código, usar variables.tf
- Sempre terraform fmt + validate antes de plan
- S3: versionamento ON, SSE AES256, lifecycle 30d -> Glacier

## Restrições
- Não deletar bucket guardiao-backup-12-09-2025.zip
- Não criar recursos sem tags
- Validar custo com `terraform plan` antes

## Como verificar
- rclone about gdrive: | grep Used (meta: < 12GB)
- terraform validate
- rclone ls gdrive:00-BACKUPS-GUARDIAO/
