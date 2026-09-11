# ACTIVE DIRECTORY PENTESTING - COMPLETE BEGINNER'S GUIDE

![Active Directory Pentesting](IMG-20260910-WA9336.jpg)

> Master AD Pentesting from Zero to Hero. Real labs, real attacks, real defense.

**[PT-BR](#-versão-em-português) | [EN](#-english-version)**

---

### 🇧🇷 Versão em Português
Guia completo para iniciantes em Pentest em Active Directory com laboratório SOC real.

**O que você vai aprender:**
- Arquitetura AD & Kerberos
- Enumeração & Recon
- Exploração de configurações incorretas
- Movimentação lateral e escalada de privilégios
- Labs + Defesa e Hardening

**Lab SOC - Detecção e Resposta:**
`Kali (brute-force) -> AD lab.local -> Detecção Python (MITRE T1110.001) -> S3 soc-evidence -> Lambda auto-remediação`

**Evidências no S3:**
- `alerts/brute-force-*.json` - Alertas Nível 10
- `incidents/INC-*.json` - Incidentes REMEDIATED
- `logs/auth.log` - Logs brutos

---
### 🇺🇸 English Version
Complete hands-on guide for beginners in Active Directory Pentesting with a real SOC Lab.

**What You Will Learn:**
- AD Architecture & Kerberos
- Enumeration & Recon
- Misconfiguration Exploitation
- Lateral Movement & Privilege Escalation
- Labs + Defense Hardening & Interview Prep

**SOC Lab - Detection & Response Pipeline:**
`Kali brute-force -> AD lab.local -> Python Detection (MITRE T1110.001) -> S3 soc-evidence -> Lambda auto-remediate`

**Tech Stack:** Active Directory, Python, Docker, AWS S3, Lambda, MITRE ATT&CK, Wazuh

⭐ Star this repo if you are learning AD Pentesting!
