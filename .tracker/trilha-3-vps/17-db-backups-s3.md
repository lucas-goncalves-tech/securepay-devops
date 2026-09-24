---
aliases: [issue-17, db-backups-s3]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-3-vps
prioridade: alta
---

# Issue #17: Backups Off-Site com Retenção e Restore Testado

## Objetivo

Garantir que perda total da VPS não significa perda de dados, com restore provado.

## O que fazer

### Etapa 1 — Rotina

**INÍCIO:** sem backup, dado único na VPS.

- [ ] Agendar dump comprimido em horário de baixo tráfego
- [ ] Enviar para storage off-site com retenção definida
- [ ] Criptografar backup em repouso

**FIM:** backup diário off-site com retenção.

---

### Etapa 2 — Prova de restore

**INÍCIO:** backup existe, restore nunca testado.

- [ ] Testar restore em ambiente limpo e medir RTO
- [ ] Definir RPO e documentar emergência em 1 página

**FIM:** 100% dos críticos restaurados no RTO; runbook executável de cabeça.

## O que aprender

### Aprender A — Banco

- [ ] Dump e restore
  - https://www.postgresql.org/docs/current/app-pgdump.html
  - https://www.postgresql.org/docs/current/app-pgrestore.html

**FIM:** sei rodar dump e restore.

---

### Aprender B — DR

- [ ] Storage e retenção
  - https://docs.aws.amazon.com/s3/
- [ ] RPO, RTO
  - https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html

**FIM:** sei definir RPO/RTO do negócio.

## Critério de pronto

1. [ ] Backup diário com retenção
2. [ ] Restore 100% no RTO
3. [ ] Runbook em 1 página

---

**Prev:** [[16-compose-isolation]]
**Next:** [[18-cicd-vps-deploy]]
**Board:** [[BOARD]]
