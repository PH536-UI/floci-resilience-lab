Do zero ao Serverless: Projeto Guardiao

Construi um pipeline serverless SQS -> Lambda -> DynamoDB usando Terraform, com 8 recursos provisionados via infraestrutura como codigo e testado localmente antes de qualquer deploy em nuvem real.

Stack: Terraform - Python 3.11 - boto3 - AWS (SQS, Lambda, DynamoDB, S3) - sa-east-1

O caso mais interessante do processo foi debugar um timeout intermitente entre Lambda e DynamoDB. A investigacao passou por tres camadas ate chegar na causa raiz:

1. Terraform nao estava reaplicando o codigo da Lambda a cada mudanca - faltava configurar o hash do pacote de deploy corretamente.
2. Depois de corrigir isso, o timeout persistiu - apontava pra um problema de resolucao de rede entre containers.
3. Testes de conectividade direta confirmaram: o endpoint usado caia no gateway Docker, que tem uma limitacao conhecida de NAT na bridge padrao do Linux - conexao trava silenciosamente, sem erro explicito, ate estourar o timeout.

O aprendizado real aqui nao foi so tecnico, foi metodologico: isolar cada camada (codigo -> infraestrutura -> rede) ate achar onde o problema realmente vivia, em vez de assumir que era "so o ambiente sendo lento".

#Terraform #AWS #DevOps #Floci
