---
aliases: [issue-17, cicd-vps-deploy]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-3-vps
prioridade: alta
---

# Issue #17: CI/CD com Gates e Deploy Contínuo via SSH

## Objetivo

Fechar o ciclo DevSecOps: cada merge verde vira deploy auditável em produção VPS sem acesso manual.

## O que fazer

### Etapa 1 — Gates antes do deploy

**INÍCIO:** deploy sem barreira.

- [ ] Reutilizar gates (segredos, SAST, SCA) como pré-requisito
- [ ] Separar produção de staging por aprovação ou filtro de branch

**FIM:** só verde deploya.

---

### Etapa 2 — Deploy auditável

**INÍCIO:** SSH manual, sem rastro.

- [ ] Deploy via SSH com chave efêmera, sem senha em log
- [ ] Healthcheck pós-deploy com rollback automático se falhar
- [ ] Registrar versão, autor e timestamp de forma auditável

**FIM:** merge vira deploy sozinho; falha reverte; versão rastreável em 30s.

## O que aprender

### Aprender A — Deploy seguro

- [ ] SSH no CI e environments
  - https://docs.github.com/en/actions/how-tos/deploy/configure-ssh-access-to-your-secrets
  - https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflows-do/use-environments-for-deployment

**FIM:** sei isolar segredo de deploy.

---

### Aprender B — Estratégia

- [ ] Blue-green e rollback
  - https://martinfowler.com/bliki/BlueGreenDeployment.html

**FIM:** sei escolher estratégia e reverter.

## Critério de pronto

1. [ ] Deploy automático só com gates verdes
2. [ ] Rollback automático em healthcheck falho
3. [ ] Auditoria em 30 segundos

---

**Prev:** [[16-db-backups-s3]]
**Board:** [[BOARD]]
