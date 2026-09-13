---
description: Gera docs completos do Projeto Guardião para GitHub + LinkedIn
allowed-tools: Bash, Read, Write, Edit
---

# Guardião Docs - Gera portfólio completo

## Step 1 - Coleta evidências

```bash
terraform state list > /tmp/state.txt
aws --endpoint-url=http://localhost:4566 s3 ls --region sa-east-1 > /tmp/s3.txt 2>&1
aws --endpoint-url=http://localhost:4566 sqs list-queues --region sa-east-1 > /tmp/sqs.txt 2>&1
cat main.tf | head -n 100
```

## Step 2 - Atualiza CLAUDE.md com o Known Issue resolvido

```bash
cat >> CLAUDE.md << 'EOF'

## Known Issues (Atualizado)
- ~~Lambda -> DynamoDB timeout é isolamento de rede Docker~~ **RESOLVIDO em 13/09/2026**:
  - Causa raiz #1: `aws_lambda_function` sem `source_code_hash` — Terraform nunca detectava mudança no lambda.zip. Fix: adicionado `source_code_hash = filebase64sha256("lambda.zip")`.
  - Causa raiz #2: `host.docker.internal` resolvia para o gateway Docker (172.17.0.1), que sofre hairpin NAT quebrado na bridge padrão do Linux — conexão trava silenciosamente até estourar os 30s, sem erro/RST.
  - Fix aplicado: `AWS_ENDPOINT_URL` apontando direto para o IP do container `floci` (172.17.0.2) em vez do gateway.
  - Fragilidade conhecida: esse IP muda se o container `floci` for recriado. Melhoria pendente: mover Lambda efêmera e `floci` para a mesma rede Docker nomeada, usando resolução por nome de container em vez de IP fixo.
EOF
```

## Step 3 - Verifica IP do floci (fragilidade conhecida)

```bash
FLOCI_IP=$(docker inspect floci --format '{{.NetworkSettings.IPAddress}}')
CURRENT_IP=$(grep AWS_ENDPOINT_URL main.tf | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
if [ "$FLOCI_IP" != "$CURRENT_IP" ]; then
  echo "IP do floci mudou ($CURRENT_IP -> $FLOCI_IP). Atualizando main.tf..."
  sed -i "s|$CURRENT_IP|$FLOCI_IP|" main.tf
fi
```

## Step 4 - Gera README.md

```bash
cat > README.md << 'EOF'
# Projeto Guardião

Pipeline serverless SQS -> Lambda -> DynamoDB, testado em ambiente LocalStack (Floci) e compatível com AWS real (sa-east-1).

## Arquitetura
- SQS: fila guardiao-queue-ph recebe mensagens
- Lambda: guardiao-processor-ph processa e persiste
- DynamoDB: guardiao-state-ph armazena estado
- S3: bucket versionado com SSE para state do Terraform

## Stack
Terraform - Python 3.11 - boto3 - AWS SQS/Lambda/DynamoDB/S3

## Evidência de Deploy
Ver guardiao-evidencia.txt para output completo do terraform state list, scan do DynamoDB, e listagens de S3/SQS.

## Known Issues
Ver seção "Known Issues (Atualizado)" no CLAUDE.md - timeout Lambda->DynamoDB resolvido, causa raiz documentada.
EOF
```

## Step 5 - Gera post para LinkedIn

```bash
cat > linkedin-post.md << 'EOF'
Do zero ao Serverless: Projeto Guardião

Construí um pipeline serverless SQS -> Lambda -> DynamoDB usando Terraform, com 8 recursos provisionados via infraestrutura como código e testado localmente antes de qualquer deploy em nuvem real.

Stack: Terraform - Python 3.11 - boto3 - AWS (SQS, Lambda, DynamoDB, S3) - sa-east-1

O caso mais interessante do processo foi debugar um timeout intermitente entre Lambda e DynamoDB. A investigação passou por três camadas até chegar na causa raiz:

1. Terraform não estava reaplicando o código da Lambda a cada mudança - faltava configurar o hash do pacote de deploy corretamente.
2. Depois de corrigir isso, o timeout persistiu - apontava pra um problema de resolução de rede entre containers.
3. Testes de conectividade direta confirmaram: o endpoint usado caía no gateway Docker, que tem uma limitação conhecida de NAT na bridge padrão do Linux - conexão trava silenciosamente, sem erro explícito, até estourar o timeout.

O aprendizado real aqui não foi só técnico, foi metodológico: isolar cada camada (código -> infraestrutura -> rede) até achar onde o problema realmente vivia, em vez de assumir que era "só o ambiente sendo lento".

#Terraform #AWS #DevOps #Floci
EOF
```

## Step 6 - Consolida tudo

```bash
echo "=== CLAUDE.md (Known Issues) ==="
tail -10 CLAUDE.md
echo "=== README gerado ==="
cat README.md
echo "=== Post LinkedIn gerado ==="
cat linkedin-post.md
```
