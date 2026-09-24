---
aliases: [issue-08, pipeline-hardening]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-1-core
prioridade: alta
---

# Issue #08: Endurecimento da Pipeline (Least-Privilege + SHA Pin)

## Objetivo

Reduzir blast radius de supply-chain attack na esteira, com permissões mínimas e ações pinadas.

## O que fazer

### Etapa 1 — Permissões mínimas

**INÍCIO:** jobs com poder demais.

- [ ] Auditar permissões de cada job e aplicar least-privilege
- [ ] Restringir escrita a apenas jobs que publicam algo

**FIM:** nenhum job com escrita desnecessária.

---

### Etapa 2 — Pinagem e auditoria

**INÍCIO:** ações por tag mutável, ataque possível.

- [ ] Pinar ações de terceiros por SHA imutável
- [ ] Criar auditoria que falha se tag mutável for usada
- [ ] Documentar política de atualização de SHA

**FIM:** auditoria passa sem tags mutáveis.

## O que aprender

### Aprender A — Hardening

- [ ] Runners e permissões
  - https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions
  - https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflows-do/controlling-permissions-for-github_token

**FIM:** sei mapear permissão mínima por job.

---

### Aprender B — Supply chain

- [ ] Ações de terceiros
  - https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-third-party-actions

**FIM:** sei explicar o ataque que cada medida previne.

## Critério de pronto

1. [ ] Auditoria sem tags mutáveis
2. [ ] Escrita mínima
3. [ ] Ameaças explicáveis

---

**Prev:** [[07-sast-semgrep]]
**Next:** [[09-observability]]
**Board:** [[BOARD]]
