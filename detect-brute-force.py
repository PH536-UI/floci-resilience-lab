#!/usr/bin/env python3
import subprocess, json, time, os
from datetime import datetime

LOG_FILE = "/tmp/auth.log"
if os.path.exists(LOG_FILE): os.remove(LOG_FILE)

print("[*] Simulando brute-force na alice...")
for i in range(10):
    cmd = 'docker exec kali-ad-lab ldapsearch -x -H ldap://ad-lab-dc -D "cn=alice,ou=users,dc=lab,dc=local" -w wrongpass -b dc=lab,dc=local 2>&1'
    subprocess.run(cmd, shell=True, capture_output=True)
    with open(LOG_FILE, "a") as f:
        f.write(f"{datetime.now()} - Failed login for alice from kali-ad-lab count={i+1}\n")
    time.sleep(0.3)

print(f"[*] Detectado BRUTE FORCE - 10 tentativas")

alert = {
    "timestamp": datetime.utcnow().isoformat(),
    "rule_id": "100200",
    "level": 10,
    "rule": "AD Brute Force Detected",
    "src_ip": "kali-ad-lab",
    "dst": "ad-lab-dc",
    "user": "alice",
    "attempts": 10,
    "mitre": "T1110.001",
    "evidence_s3": "s3://soc-evidence/alerts/"
}

with open("/tmp/wazuh-alert.json", "w") as f:
    json.dump(alert, f, indent=2)

os.system(f"aws --endpoint-url=http://localhost:4566 s3 cp /tmp/wazuh-alert.json s3://soc-evidence/alerts/brute-force-{int(time.time())}.json")
os.system(f"aws --endpoint-url=http://localhost:4566 s3 cp {LOG_FILE} s3://soc-evidence/logs/auth.log")
print("[+] Alerta enviado pro S3 soc-evidence")
os.system(f"aws --endpoint-url=http://localhost:4566 s3 ls s3://soc-evidence/ --recursive")
os.system(f"cat /tmp/wazuh-alert.json")
