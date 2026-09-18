---
aliases: [issue-12, aws-production]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-2-micro-k8s
prioridade: media
---

# Issue #12: Nuvem Real com Estado Remoto e Lock

## Objetivo

Operar infra real com estado compartilhado e travas contra apply concorrente, mais computação dedicada.

## O que fazer

- [ ] Migrar estado Terraform local para backend remoto com versionamento
- [ ] Ativar locking contra applies concorrentes
- [ ] Provisionar computação real mínima para API e banco gerenciado ou VM
- [ ] Separar ambientes por workspace ou prefixo de estado
- [ ] Estimar custo mensal antes de subir e desligar após validar

## O que aprender

- [ ] Backends remotos e locking
  - https://developer.hashicorp.com/terraform/language/backend
  - https://docs.aws.amazon.com/s3/
  - https://docs.aws.amazon.com/dynamodb/
- [ ] FinOps básico: calculadora e right-sizing
  - https://calculator.aws.amazon.com/

## Critério de pronto

- Dois applies simultâneos não corrompem o estado
- Custo estimado documentado antes do apply real
- Sei destruir tudo sem deixar recurso órfão cobrado

---

**Prev:** [[11-kubernetes-helm]]
**Next:** [[13-vps-hardening]]
**Board:** [[BOARD]]
