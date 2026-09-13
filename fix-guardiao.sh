#!/bin/bash
set -e

echo "=== 1. Lista recursos com regiao correta ==="
aws --endpoint-url=http://localhost:4566 sqs list-queues --region sa-east-1
aws --endpoint-url=http://localhost:4566 dynamodb list-tables --region sa-east-1

echo "=== 2. Importa bucket S3 existente para o state do Terraform ==="
terraform import aws_s3_bucket.terraform_state ph-terraform-state-536
terraform apply -auto-approve

echo "=== 3. Confirma 8/8 recursos ==="
terraform state list
echo "Total:"
terraform state list | wc -l

echo "=== 4. Testa pipeline de verdade, com regiao explicita ==="
aws --endpoint-url=http://localhost:4566 sqs send-message \
  --queue-url http://localhost:4566/000000000000/guardiao-queue-ph \
  --message-body '{"id":"ph-007","data":"re-criado apos restart floci"}' \
  --region sa-east-1

sleep 3
aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name guardiao-state-ph --region sa-east-1

echo "=== 5. Limpa artefatos indevidos do repo (SO roda isso se o scan acima mostrou ph-007) ==="
echo "Revise o scan acima antes de continuar. Pressione Ctrl+C agora se ph-007 NAO apareceu."
sleep 5

git rm -r --cached lambda/__pycache__ 2>/dev/null || true
git rm --cached tfplan 2>/dev/null || true
git rm --cached 8 2>/dev/null || true

cat >> .gitignore << 'EOF'
__pycache__/
*.pyc
tfplan
EOF

git add .gitignore
git status
