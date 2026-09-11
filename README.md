# 🔧 LAB FLOCI Terraform - 100 AWS Services Local

> Simulando AWS real localmente com FLOCI + Terraform + Docker

### 🇧🇷 PT-BR
Lab completo para testar Terraform sem gastar na AWS. Roda 100 serviços AWS localmente.

**O que roda:**
- FLOCI - Mock de 100 serviços AWS
- NGINX simulando EC2 com disco cheio (cenário de falha)
- Terraform validado localmente

**Como rodar:**
docker compose up -d
curl http://localhost:4566/_floci/health

Stack: FLOCI | Terraform | Docker | AWS | Nginx

### 🇺🇸 EN
Complete lab to test Terraform without AWS costs. Runs 100 AWS services locally.
