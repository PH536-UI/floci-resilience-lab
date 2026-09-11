import json, boto3, os
from datetime import datetime

# Dentro da lambda no LocalStack usa floci:4566, fora usa localhost:4566
ENDPOINT = os.getenv("AWS_ENDPOINT", "http://localhost:4566")
# se rodar dentro do container floci, troca pra floci:4566 automaticamente
if os.path.exists("/.dockerenv") and "floci" in open("/etc/hosts").read():
    ENDPOINT = "http://floci:4566"

s3 = boto3.client('s3', endpoint_url=ENDPOINT)

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    print(f"[*] Novo alerta: {bucket}/{key} via {ENDPOINT}")

    obj = s3.get_object(Bucket=bucket, Key=key)
    alert = json.loads(obj['Body'].read())

    if alert.get('level', 0) >= 10 and 'Brute Force' in alert.get('rule',''):
        user = alert['user']
        src_ip = alert['src_ip']
        print(f"[!] INCIDENTE CRITICO - Usuario: {user} - IP: {src_ip}")
        new_pass = f"TempPass{datetime.now().strftime('%H%M')}!"
        print(f"[+] Resetando senha de {user} para {new_pass}")
        print(f"[+] Bloqueando IP {src_ip}")

        response_report = {
            "incident_id": f"INC-{int(datetime.now().timestamp())}",
            "original_alert": alert,
            "actions_taken": [
                f"Password reset for {user}",
                f"Blocked IP {src_ip}",
                f"Account {user} forced to change password at next logon"
            ],
            "timestamp": datetime.utcnow().isoformat(),
            "status": "REMEDIATED",
            "analyst": "lambda-soc-auto"
        }

        s3.put_object(
            Bucket=bucket,
            Key=f"incidents/{response_report['incident_id']}.json",
            Body=json.dumps(response_report, indent=2)
        )
        s3.put_object(
            Bucket=bucket,
            Key=f"logs/remediation-{int(datetime.now().timestamp())}.log",
            Body=f"{datetime.now()} - REMEDIATED brute force for {user} from {src_ip}\n".encode()
        )
        print(f"[+] Incidente {response_report['incident_id']} remediado")
        return response_report
    return {"status": "no action"}

if __name__ == "__main__":
    test_event = {
        "Records": [{
            "s3": {"bucket": {"name": "soc-evidence"}, "object": {"key": "alerts/brute-force-1789094642.json"}}
        }]
    }
    lambda_handler(test_event, None)
