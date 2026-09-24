---
aliases: [issue-06, secrets-hygiene]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-1-core
prioridade: alta
---

# Issue #06: Higiene de Segredos e Anti-Vazamento

## Objetivo

Impedir que credenciais e arquivos de ambiente vazem para o git, com detecção automática no CI.

## O que fazer

### Etapa 1 — Detecção

**INÍCIO:** segredo pode passar despercebido.

- [ ] Adotar scanner de segredos no pré-commit e no CI
- [ ] Criar baseline de achados legítimos vs vazamento real

**FIM:** baseline existe; scanner distingue falso positivo de vazamento.

---

### Etapa 2 — Bloqueio e higiene

**INÍCIO:** detecção sem consequência.

- [ ] Bloquear merge se novo segredo for detectado
- [ ] Higienizar variáveis sensíveis em arquivos de exemplo
- [ ] Documentar fluxo: exemplo versionado + valor real só via ambiente/secret

**FIM:** commit com chave mock é barrado; fluxo seguro documentado.

## O que aprender

### Aprender A — Segredos

- [ ] Gestão e higiene em repos
  - https://gitleaks.io/
  - https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions

**FIM:** sei dizer onde o segredo mora em cada ambiente.

## Critério de pronto

1. [ ] Chave mock barrada automaticamente
2. [ ] Baseline funcional
3. [ ] Explicação local/CI/prod

---

**Prev:** [[05-github-actions]]
**Next:** [[07-sast-semgrep]]
**Board:** [[BOARD]]
