# 💥 TERRAFORM AWS FAULT INJECTION LAB
### 100 AWS Services Mocked Locally | FLOCI + Chaos Engineering

> Testando resiliência AWS sem gastar 1 dólar | Testing AWS resilience without spending $1

**Stack:** Terraform | FLOCI | Docker | AWS | Nginx | Chaos Engineering

### PT-BR
Laboratório de Fault Injection que simula infra AWS completa LOCALMENTE.
- EC2 com disco cheio (NGINX tmpfs limitado)
- FLOCI rodando 100 serviços AWS mockados
- Terraform validando local

Como rodar:
docker compose up -d
curl http://localhost:4566/_floci/health

### EN
Fault Injection Lab simulating full AWS locally. 100 services mocked.
