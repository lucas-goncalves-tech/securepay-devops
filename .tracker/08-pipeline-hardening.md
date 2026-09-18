---
aliases: [issue-08, pipeline-hardening]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: ponte-devsecops
prioridade: alta
---

# Issue #08: Endurecimento da Pipeline (Least-Privilege + SHA Pin)

## Objetivo

Reduzir blast radius de supply-chain attack na esteira, com permissões mínimas e ações pinadas.

## O que fazer

- [ ] Auditar permissões de cada job e aplicar least-privilege
- [ ] Pinar ações de terceiros por SHA imutável em vez de tag mutável
- [ ] Criar script de auditoria que falha se tag mutável for usada
- [ ] Restringir escrita a apenas jobs que publicam algo
- [ ] Documentar política de atualização de SHA

## O que aprender

- [ ] Hardening de runners e permissões
  - https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions
  - https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflows-do/controlling-permissions-for-github_token
- [ ] Supply chain e pinagem de dependências
  - https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-third-party-actions

## Critério de pronto

- Auditoria automática passa sem tags mutáveis
- Nenhum job tem permissão de escrita desnecessária
- Sei explicar o ataque que cada medida previne

---

**Prev:** [[07-sast-semgrep]]
**Next:** [[04-github-actions]]
**Board:** [[BOARD]]
