---
aliases: [issue-07, sast-semgrep]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: ponte-devsecops
prioridade: alta
---

# Issue #07: SAST com Regras Bloqueantes

## Objetivo

Barrar padrões inseguros no código Java antes do merge, sem depender de revisão humana para o óbvio.

## O que fazer

- [ ] Adotar scanner SAST com regras focadas em Java
- [ ] Ativar modo bloqueante apenas para severidade ERROR
- [ ] Integrar ao CI como gate obrigatório
- [ ] Zerar violações ERROR existentes ou justificar como exceção
- [ ] Documentar como adicionar nova regra sem quebrar a pipeline à toa

## O que aprender

- [ ] Análise estática e shift-left security
  - https://semgrep.dev/docs/
  - https://owasp.org/www-project-top-ten/

## Critério de pronto

- PR com padrão inseguro mapeado falha automaticamente
- Zero ERROR aberto sem justificativa registrada
- Sei explicar diferença SAST vs SCA vs scan de segredos

---

**Prev:** [[06-secrets-hygiene]]
**Next:** [[08-pipeline-hardening]]
**Board:** [[BOARD]]
