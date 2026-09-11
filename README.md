# 💥 floci-resilience-lab

### 100 AWS Services Mocked Locally | Fault Injection + Chaos Engineering
**Testando resiliencia AWS sem gastar $1**

Stack: Terraform | FLOCI | Docker | AWS | Nginx | Chaos Engineering

## PT-BR - O que e?
Laboratorio de Fault Injection que simula infra AWS completa LOCALMENTE.
- EC2 com disco cheio (Nginx tmpfs limitado)
- FLOCI rodando 100 servicos AWS mockados
- Terraform validando local
- Lambda Python auto-remediacao

> Roda 100% offline. 0 custo AWS.

## Como rodar
docker compose up -d
curl http://localhost:4566/_floci/health
cd terraform && terraform init && terraform plan

## EN
Fault Injection Lab simulating full AWS locally. 100 services mocked.

## Autor
Paulo Henrique Pereira | 4x AWS Certified | SRE | Piracicaba-SP
