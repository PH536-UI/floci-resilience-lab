
## Known Issues (Atualizado)
- ~~Lambda -> DynamoDB timeout é isolamento de rede Docker~~ **RESOLVIDO em 13/09/2026**:
  - Causa raiz #1: `aws_lambda_function` sem `source_code_hash` — Terraform nunca detectava mudança no lambda.zip. Fix: adicionado `source_code_hash = filebase64sha256("lambda.zip")`.
  - Causa raiz #2: `host.docker.internal` resolvia para o gateway Docker (172.17.0.1), que sofre hairpin NAT quebrado na bridge padrão do Linux — conexão trava silenciosamente até estourar os 30s, sem erro/RST.
  - Fix aplicado: `AWS_ENDPOINT_URL` apontando direto para o IP do container `floci` (172.17.0.2) em vez do gateway.
  - ⚠️ Fragilidade conhecida: esse IP muda se o container `floci` for recriado. Melhoria pendente: mover Lambda efêmera e `floci` para a mesma rede Docker nomeada, usando resolução por nome de container em vez de IP fixo.
