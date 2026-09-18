---
aliases: [issue-04, github-actions, stage-04]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-1-core
prioridade: alta
---

# Issue #04: Esteira CI/CD com Testes, Trivy e Gate IaC

## Objetivo

Automatizar build, teste, scan de vulnerabilidades e validação de infra a cada push, com otimização de custo em staging.

## O que fazer

- [ ] Criar workflow com gatilhos `push` e `pull_request` em `main`/`master`, separando job de backend e job de IaC por filtro de mudanças
- [ ] Job backend: Java 21 LTS com `cache: maven` + `./mvnw verify` (ou `clean test`)
- [ ] Job container-security: build da imagem + scan Trivy que falha em `HIGH,CRITICAL`
- [ ] Job terraform-gate: `fmt -check` → `init` → `validate` → `plan` contra emulador local (`localstack/localstack:4.4.0`, porta `4566`, `SERVICES=s3,ec2`, região `sa-east-1`)
- [ ] Job staging-cost-optimizer: cron `0 22 * * 1-5` para pausar staging + `workflow_dispatch` com input `start`/`stop`
- [ ] Exigir pipeline verde como pré-requisito de merge; YAML íntegro com indentação válida

## O que aprender

- [ ] Sintaxe de workflows, jobs, triggers e filtros de path
  - https://docs.github.com/en/actions/writing-workflows
  - https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run
- [ ] Build Java com Maven no CI com cache
  - https://github.com/actions/setup-java
  - https://maven.apache.org/surefire/maven-surefire-plugin/
- [ ] Scan de imagem com Trivy em modo bloqueante
  - https://aquasecurity.github.io/trivy/
  - https://github.com/aquasecurity/trivy-action
- [ ] Automação Terraform no CI
  - https://developer.hashicorp.com/terraform/tutorials/github-actions

## Critério de pronto

- Push com teste quebrado ou vulnerabilidade `HIGH`/`CRITICAL` falha o pipeline
- Erro de `fmt` ou `validate` IaC bloqueia merge
- Staging desliga no cron noturno e religa sob demanda via `workflow_dispatch`
- Sei explicar cada gate e seu custo se removido

## Fora de escopo

- Proibido: GitOps ArgoCD/Flux, deploy ECS Fargate, Ansible
- Foco exclusivo: workflow YAML, build e testes Maven, build Docker, Trivy em `HIGH,CRITICAL`, `fmt` e `validate`

---

**Prev:** [[08-pipeline-hardening]]
**Next:** [[05-observability]]
**Board:** [[BOARD]]
