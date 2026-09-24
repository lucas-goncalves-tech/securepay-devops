---
aliases: [issue-13, aws-production]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-2-micro-k8s
prioridade: media
---

# Issue #13: Nuvem Real com Estado Remoto e Lock

## Objetivo

Operar infra real com estado compartilhado e travas contra apply concorrente, mais computação dedicada.

## O que fazer

### Etapa 1 — Estado seguro

**INÍCIO:** estado local, apply concorrente corrompe.

- [ ] Migrar estado para backend remoto com versionamento
- [ ] Ativar locking contra applies concorrentes
- [ ] Separar ambientes por workspace ou prefixo

**FIM:** dois applies simultâneos não corrompem.

---

### Etapa 2 — Custo e computação

**INÍCIO:** custo desconhecido.

- [ ] Estimar custo mensal antes de subir
- [ ] Provisionar computação mínima para API e banco
- [ ] Desligar após validar, sem órfãos

**FIM:** custo documentado; destroy limpo.

## O que aprender

### Aprender A — Backend remoto

- [ ] Backends e locking
  - https://developer.hashicorp.com/terraform/language/backend
  - https://docs.aws.amazon.com/s3/
  - https://docs.aws.amazon.com/dynamodb/

**FIM:** sei explicar state + lock.

---

### Aprender B — FinOps

- [ ] Calculadora e right-sizing
  - https://calculator.aws.amazon.com/

**FIM:** sei estimar antes de aplicar.

## Critério de pronto

1. [ ] Lock funcional
2. [ ] Custo pré-documentado
3. [ ] Destroy sem cobrança residual

---

**Prev:** [[12-kubernetes-helm]]
**Next:** [[14-vps-hardening]]
**Board:** [[BOARD]]
