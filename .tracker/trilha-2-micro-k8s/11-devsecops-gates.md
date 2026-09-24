---
aliases: [issue-11, devsecops-gates]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-2-micro-k8s
prioridade: alta
---

# Issue #11: Quality Gates DevSecOps no CI

## Objetivo

Aparafusar higiene de segredos, SAST e SCA na pipeline multi-serviço como gates bloqueantes.

## O que fazer

### Etapa 1 — Três gates

**INÍCIO:** pipeline só testa, não protege.

- [ ] Gate 1: segredos bloqueando vazamento
- [ ] Gate 2: SAST bloqueando padrões inseguros
- [ ] Gate 3: SCA bloqueando CVEs altas e críticas

**FIM:** cada gate falha isolado com mensagem acionável.

---

### Etapa 2 — Sintonia

**INÍCIO:** gates barulhentos ou lentos.

- [ ] Diferenciar severidade que falha vs que só alerta
- [ ] Medir tempo adicionado e otimizar com cache

**FIM:** verde significa limpo; custo em minutos conhecido.

## O que aprender

### Aprender A — Gates

- [ ] DevSecOps
  - https://owasp.org/www-project-devsecops-guideline/

**FIM:** sei posicionar cada gate no fluxo.

---

### Aprender B — SCA

- [ ] CVEs e dependências
  - https://aquasecurity.github.io/trivy/
  - https://docs.github.com/en/code-security/dependabot

**FIM:** sei triar CVE relevante vs ruído.

## Critério de pronto

1. [ ] Falhas isoladas e acionáveis
2. [ ] Verde = sem segredo, sem ERROR, sem CVE alta/crítica
3. [ ] Tempo por gate medido

---

**Prev:** [[10-containers-redis]]
**Next:** [[12-kubernetes-helm]]
**Board:** [[BOARD]]
