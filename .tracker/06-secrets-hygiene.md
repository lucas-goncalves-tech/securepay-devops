---
aliases: [issue-06, secrets-hygiene]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: ponte-devsecops
prioridade: alta
---

# Issue #06: Higiene de Segredos e Anti-Vazamento

## Objetivo

Impedir que credenciais e arquivos de ambiente vazem para o git, com detecção automática no CI.

## O que fazer

- [ ] Adotar scanner de segredos no pré-commit e no CI
- [ ] Criar baseline de achados legítimos vs vazamento real
- [ ] Bloquear merge se novo segredo for detectado
- [ ] Higienizar histórico de variáveis sensíveis em arquivos de exemplo
- [ ] Documentar fluxo seguro: exemplo versionado + valor real só via ambiente/secret

## O que aprender

- [ ] Gestão de segredos e higiene em repos
  - https://gitleaks.io/
  - https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions

## Critério de pronto

- Commit com chave mock é barrado automaticamente
- Baseline existe e pipeline distingue falso positivo de vazamento real
- Sei explicar onde o segredo mora em cada ambiente (local, CI, prod)

---

**Prev:** [[03-terraform-vpc]]
**Next:** [[07-sast-semgrep]]
**Board:** [[BOARD]]
