#!/bin/bash
cd ~/lab-floci-terraform
docker compose -f docker-compose.lab.yml up -d --remove-orphans
sleep 10
docker exec ad-lab-dc bash -c 'ldapdelete -x -D cn=admin,dc=lab,dc=local -w Password123 -r ou=users,dc=lab,dc=local 2>/dev/null; true'

cat <<'EOF' | docker exec -i ad-lab-dc ldapadd -x -D cn=admin,dc=lab,dc=local -w Password123
dn: ou=users,dc=lab,dc=local
objectClass: organizationalUnit
ou: users

dn: cn=alice,ou=users,dc=lab,dc=local
objectClass: inetOrgPerson
cn: alice
sn: Silva
uid: alice
userPassword: Password123

dn: cn=bob,ou=users,dc=lab,dc=local
objectClass: inetOrgPerson
cn: bob
sn: Santos
uid: bob
userPassword: Password123

dn: cn=carol,ou=users,dc=lab,dc=local
objectClass: inetOrgPerson
cn: carol
sn: Oliveira
uid: carol
userPassword: Password123
EOF

awslocal s3api create-bucket --bucket soc-evidence 2>/dev/null; true
echo "--- SOC PRONTO ---"
docker exec kali-ad-lab bash -c 'ldapsearch -x -H ldap://ad-lab-dc -b ou=users,dc=lab,dc=local -D cn=admin,dc=lab,dc=local -w Password123 cn | grep "^dn:"'
