---
aliases: [issue-03, terraform-vpc, stage-03]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-1-core
prioridade: alta
---

# Issue #03: Infraestrutura como Código com Terraform e VPC Multi-Tier

## Objetivo

Declarar rede e storage de forma idempotente em ambiente local compatível com AWS, com banco isolado e sem vazamento de porta sensível.

## O que fazer

### Etapa 1 — Provider e emulador

**INÍCIO:** nada declarado, nuvem local fora do ar.

- [ ] Declarar provider `hashicorp/aws` `~> 5.0`, endpoints `ec2` e `s3` em `http://localhost:4566`, região `sa-east-1`, credenciais mock, com `skip_credentials_validation` e `skip_requesting_account_id`
- [ ] Subir emulador local com `SERVICES=s3,ec2`, região `sa-east-1`, endpoint respondendo

**FIM:** endpoint local responde; `init` e `validate` passam.

---

### Etapa 2 — Rede multi-tier

**INÍCIO:** provider ok, rede única ou inexistente.

- [ ] Criar VPC `10.0.0.0/16`
- [ ] Criar pública `10.0.1.0/24` (load balancers), privada `10.0.2.0/24` (API) e isolada `10.0.3.0/24` (banco sem rota internet)

**FIM:** três tiers endereçados e segregados.

---

### Etapa 3 — Segurança e storage

**INÍCIO:** rede existe, mas banco pode estar exposto.

- [ ] Criar SG da API com entrada `8080` e SG do banco com entrada `5432` exclusivamente via SG da API; nunca `0.0.0.0/0`
- [ ] Criar bucket `securepay-financial-reports` com os 4 bloqueios (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`)

**FIM:** banco só via SG da API; bucket 100% privado.

---

### Etapa 4 — Apply sem drift

**INÍCIO:** código pronto, estado não aplicado.

- [ ] Executar `init` → `validate` → `apply -auto-approve` → `plan -detailed-exitcode` com exit 0

**FIM:** plan final exit 0, sem pendências.

## O que aprender

### Aprender A — Terraform base

- [ ] HCL, estado e drift
  - https://developer.hashicorp.com/terraform/docs
  - https://developer.hashicorp.com/terraform/cli/commands/plan

**FIM:** sei explicar idempotência e drift.

---

### Aprender B — Rede e storage AWS

- [ ] VPC, subnets, route tables, SGs
  - https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
  - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html
- [ ] S3 e bloqueio público
  - https://docs.aws.amazon.com/s3/

**FIM:** sei justificar 3 tiers e SG encadeado.

---

### Aprender C — Emulador local

- [ ] Integração com Terraform
  - https://docs.localstack.cloud/user-guide/integrations/terraform/

**FIM:** sei apontar endpoint e serviços emulados.

## Critério de pronto

1. [ ] `plan -detailed-exitcode` exit 0
2. [ ] `5432` jamais em `0.0.0.0/0`
3. [ ] Bucket privado com 4 bloqueios; VPC e subnets exatas

## Fora de escopo

- Proibido: Kubernetes, Helm, CloudWatch Logs avançado, EKS, esteiras de CI/CD
- Foco exclusivo: HCL, provider local em `localhost:4566`, VPC multi-tier, SGs sem vazamento em `5432`, bucket privado e drift via `plan`

---

**Prev:** [[02-docker-compose]]
**Next:** [[06-secrets-hygiene]]
**Board:** [[BOARD]]
