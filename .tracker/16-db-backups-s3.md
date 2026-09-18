---
aliases: [issue-16, db-backups-s3]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-3-vps
prioridade: alta
---

# Issue #16: Backups Off-Site com Retenção e Restore Testado

## Objetivo

Garantir que perda total da VPS não significa perda de dados, com restore provado.

## O que fazer

- [ ] Agendar dump comprimido do banco em horário de baixo tráfego
- [ ] Enviar para storage off-site com retenção definida
- [ ] Criptografar backup em repouso
- [ ] Testar restore em ambiente limpo e medir tempo (RTO)
- [ ] Definir RPO e documentar procedimento de emergência em 1 página

## O que aprender

- [ ] Backup e restore PostgreSQL
  - https://www.postgresql.org/docs/current/app-pgdump.html
  - https://www.postgresql.org/docs/current/app-pgrestore.html
- [ ] Storage e lifecycle de retenção
  - https://docs.aws.amazon.com/s3/
- [ ] RPO, RTO e plano de DR
  - https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html

## Critério de pronto

- Backup diário existe off-site com retenção aplicada
- Restore testado restaura 100% dos dados críticos dentro do RTO
- Sei executar o runbook de cabeça em incidente simulado

---

**Prev:** [[15-compose-isolation]]
**Next:** [[17-cicd-vps-deploy]]
**Board:** [[BOARD]]
