# Lab FLOCI Terraform - SOC + AD + S3
Lab 100% local, custo zero AWS.

## Arquitetura
- LocalStack 3.6 -> S3 soc-evidence versioning Enabled
- OpenLDAP -> lab.local com alice/bob/carol
- Kali -> ldapsearch

## Validado 11/09/2026 02:15 UTC
- Bucket soc-evidence 62 bytes OK
- AD 3 users OK
- ldapsearch 5 entries OK

## Como rodar
./start-soc.sh
aws --endpoint-url=http://localhost:4566 s3 ls s3://soc-evidence/

