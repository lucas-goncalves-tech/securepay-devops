---
aliases: [issue-05, github-actions, stage-04]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-1-core
prioridade: alta
---

# Issue #05: Esteira CI/CD com Testes, Trivy e Gate IaC

## Objetivo

Automatizar build, teste, scan de vulnerabilidades e validação de infra a cada push, com otimização de custo em staging.

## O que fazer

### Etapa 1 — Workflow e backend

**INÍCIO:** entrega manual, teste quebrado passa batido.

- [ ] Criar workflow com `push` e `pull_request` em `main`/`master`, separando backend e IaC por filtro de mudanças
- [ ] Job backend: Java 21 com `cache: maven` + `./mvnw verify` (ou `clean test`)
- [ ] Exigir YAML íntegro e pipeline verde como pré-requisito de merge

**FIM:** teste quebrado falha o pipeline e bloqueia merge.

---

### Etapa 2 — Segurança de imagem

**INÍCIO:** imagem pode ir a produção com CVE.

- [ ] Job container-security: build + scan Trivy que falha em `HIGH,CRITICAL`

**FIM:** CVE alta/crítica barra o merge.

---

### Etapa 3 — Gate IaC

**INÍCIO:** Terraform quebrado só aparece no deploy.

- [ ] Job terraform-gate: `fmt -check` → `init` → `validate` → `plan` contra emulador (`localstack/localstack:4.4.0`, porta `4566`, `SERVICES=s3,ec2`, `sa-east-1`)

**FIM:** erro de `fmt`/`validate` bloqueia merge.

---

### Etapa 4 — FinOps staging

**INÍCIO:** staging ligado 24/7 gerando custo.

- [ ] Job staging-cost-optimizer: cron `0 22 * * 1-5` + `workflow_dispatch` com `start`/`stop`

**FIM:** staging desliga à noite e religa sob demanda.

## O que aprender

### Aprender A — Actions base

- [ ] Workflows, triggers e filtros
  - https://docs.github.com/en/actions/writing-workflows
  - https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run

**FIM:** sei explicar quando cada job dispara.

---

### Aprender B — Java e Trivy

- [ ] Build Maven com cache
  - https://github.com/actions/setup-java
  - https://maven.apache.org/surefire/maven-surefire-plugin/
- [ ] Scan bloqueante
  - https://aquasecurity.github.io/trivy/
  - https://github.com/aquasecurity/trivy-action

**FIM:** sei dizer o custo em minutos de cada gate.

---

### Aprender C — IaC no CI

- [ ] Automação Terraform
  - https://developer.hashicorp.com/terraform/tutorials/github-actions

**FIM:** sei ler um `plan` no log do CI.

## Critério de pronto

1. [ ] Teste quebrado ou CVE `HIGH`/`CRITICAL` falha
2. [ ] `fmt`/`validate` bloqueiam merge
3. [ ] Staging com cron + dispatch funcionando

## Fora de escopo

- Proibido: GitOps ArgoCD/Flux, deploy ECS Fargate, Ansible
- Foco exclusivo: workflow YAML, build e testes Maven, build Docker, Trivy em `HIGH,CRITICAL`, `fmt` e `validate`

---

**Prev:** [[04-s3-reports-infra]]
**Next:** [[06-secrets-hygiene]]
**Board:** [[BOARD]]
