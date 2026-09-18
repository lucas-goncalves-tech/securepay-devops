---
aliases: [issue-10, devsecops-gates]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-2-micro-k8s
prioridade: alta
---

# Issue #10: Quality Gates DevSecOps no CI

## Objetivo

Aparafusar higiene de segredos, SAST e SCA na pipeline multi-serviço como gates bloqueantes.

## O que fazer

- [ ] Gate 1: scan de segredos bloqueando vazamento
- [ ] Gate 2: SAST bloqueando padrões inseguros
- [ ] Gate 3: SCA (dependências e imagem) bloqueando CVEs altas e críticas
- [ ] Diferenciar severidade que falha vs que só alerta
- [ ] Medir tempo adicionado pelos gates e otimizar com cache

## O que aprender

- [ ] DevSecOps e quality gates
  - https://owasp.org/www-project-devsecops-guideline/
- [ ] SCA e gestão de CVEs
  - https://aquasecurity.github.io/trivy/
  - https://docs.github.com/en/code-security/dependabot

## Critério de pronto

- Cada gate falha isoladamente com mensagem acionável
- Pipeline verde significa sem segredo, sem ERROR SAST e sem CVE alta/crítica
- Sei dizer custo em minutos de cada gate

---

**Prev:** [[09-containers-redis]]
**Next:** [[11-kubernetes-helm]]
**Board:** [[BOARD]]
