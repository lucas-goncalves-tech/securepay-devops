---
aliases: [issue-14, vps-hardening]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-3-vps
prioridade: alta
---

# Issue #14: Hardening de VPS para Produção Econômica

## Objetivo

Deixar servidor barato apto a produção com acesso mínimo, firewall e proteção contra força bruta.

## O que fazer

### Etapa 1 — Acesso

**INÍCIO:** root com senha, superfície aberta.

- [ ] Criar usuário operacional com sudo, sem senha direta para root
- [ ] Desativar login por senha, exigir só chave SSH

**FIM:** senha recusada; só chave passa.

---

### Etapa 2 — Blindagem

**INÍCIO:** portas expostas, sem ban.

- [ ] Ativar firewall só para SSH, HTTP e HTTPS
- [ ] Ativar ban temporário contra brute-force
- [ ] Configurar swap anti-OOM
- [ ] Auditar portas e fechar o não-público

**FIM:** scan externo só vê o essencial; brute-force gera ban.

## O que aprender

### Aprender A — SSH e firewall

- [ ] Hardening
  - https://www.ssh.com/academy/ssh/hardening
  - https://help.ubuntu.com/community/UFW

**FIM:** sei justificar cada porta aberta.

---

### Aprender B — Proteção contínua

- [ ] Fail2ban e benchmarks
  - https://www.fail2ban.org/wiki/index.php/Main_Page
  - https://www.cisecurity.org/cis-benchmarks

**FIM:** sei ler ban ativo no log.

## Critério de pronto

1. [ ] Só chave autentica
2. [ ] Firewall mínimo
3. [ ] Ban automático funcional

---

**Prev:** [[13-aws-production]]
**Next:** [[15-caddy-reverse-proxy]]
**Board:** [[BOARD]]
