---
aliases: [issue-07, sast-semgrep]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-1-core
prioridade: alta
---

# Issue #07: SAST com Regras Bloqueantes

## Objetivo

Barrar padrões inseguros no código Java antes do merge, sem depender de revisão humana para o óbvio.

## O que fazer

### Etapa 1 — Gate SAST

**INÍCIO:** padrão inseguro só aparece em revisão (ou nunca).

- [ ] Adotar scanner SAST com regras focadas em Java
- [ ] Ativar modo bloqueante apenas para severidade ERROR
- [ ] Integrar ao CI como gate obrigatório

**FIM:** PR com padrão mapeado falha sozinho.

---

### Etapa 2 — Zerar e governar

**INÍCIO:** gate existe, mas backlog ERROR aberto.

- [ ] Zerar violações ERROR ou justificar como exceção registrada
- [ ] Documentar como adicionar regra sem quebrar a pipeline à toa

**FIM:** zero ERROR sem justificativa.

## O que aprender

### Aprender A — SAST

- [ ] Análise estática e shift-left
  - https://semgrep.dev/docs/
  - https://owasp.org/www-project-top-ten/

**FIM:** sei diferenciar SAST vs SCA vs scan de segredos.

## Critério de pronto

1. [ ] Gate bloqueante ativo
2. [ ] Zero ERROR injustificado
3. [ ] Política de novas regras

---

**Prev:** [[06-secrets-hygiene]]
**Next:** [[08-pipeline-hardening]]
**Board:** [[BOARD]]
