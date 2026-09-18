---
aliases: [issue-13, vps-hardening]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-3-vps
prioridade: alta
---

# Issue #13: Hardening de VPS para Produção Econômica

## Objetivo

Deixar servidor barato apto a produção com acesso mínimo, firewall e proteção contra força bruta.

## O que fazer

- [ ] Criar usuário operacional com sudo sem senha direta para root
- [ ] Desativar login por senha e exigir apenas chave SSH
- [ ] Ativar firewall permitindo só SSH, HTTP e HTTPS
- [ ] Ativar proteção contra brute-force com ban temporário
- [ ] Configurar swap para evitar OOM sob pico de memória
- [ ] Auditar portas expostas e fechar tudo que não é público

## O que aprender

- [ ] Hardening SSH e UFW
  - https://www.ssh.com/academy/ssh/hardening
  - https://help.ubuntu.com/community/UFW
- [ ] Fail2ban e segurança de VPS
  - https://www.fail2ban.org/wiki/index.php/Main_Page
  - https://www.cisecurity.org/cis-benchmarks

## Critério de pronto

- Login por senha recusado, só chave passa
- Scan externo só vê portas públicas essenciais
- Ataque de força bruta gera ban automático
- Sei explicar cada porta aberta e por quê

---

**Prev:** [[12-aws-production]]
**Next:** [[14-caddy-reverse-proxy]]
**Board:** [[BOARD]]
