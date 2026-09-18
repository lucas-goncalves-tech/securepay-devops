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

- [ ] Criar workflow com gatilhos em push e PR para branches principais, separando job de backend e job de IaC por filtro de mudanças
- [ ] Job backend: build Java LTS com cache Maven + testes automatizados
- [ ] Job container-security: build da imagem + scan falhando em severidade alta e crítica
- [ ] Job terraform-gate: fmt check → init → validate → plan contra emulador local
- [ ] Job staging-cost-optimizer: stop/start programado em horário comercial + disparo manual
- [ ] Exigir pipeline verde como pré-requisito de merge

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

- Push com teste quebrado ou vulnerabilidade crítica falha o pipeline
- Erro de formatação ou validação IaC bloqueia merge
- Sei explicar cada gate e seu custo se removido

---

**Prev:** [[08-pipeline-hardening]]
**Next:** [[05-observability]]
**Board:** [[BOARD]]
