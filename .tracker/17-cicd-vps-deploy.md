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

- [ ] Reutilizar gates (segredos, SAST, SCA de imagem) como pré-requisito de deploy
- [ ] Deploy via SSH com chave efêmera de CI, sem senha em log
- [ ] Estratégia com healthcheck pós-deploy e rollback automático se falhar
- [ ] Registrar o que foi deployado (versão, autor, timestamp) de forma auditável
- [ ] Separar deploy de produção de staging por aprovação ou filtro de branch

## O que aprender

- [ ] Deploy contínuo seguro via SSH
  - https://docs.github.com/en/actions/how-tos/deploy/configure-ssh-access-to-your-secrets
  - https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflows-do/use-environments-for-deployment
- [ ] Estratégias de deploy e rollback
  - https://martinfowler.com/bliki/BlueGreenDeployment.html

## Critério de pronto

- Merge na principal com gates verdes resulta em deploy sem toque manual
- Deploy com healthcheck falho reverte sozinho
- Sei dizer em 30s qual versão está em prod e quem deployou

---

**Prev:** [[16-db-backups-s3]]
**Board:** [[BOARD]]
