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

- [ ] Declarar provider AWS apontando para endpoint local, região sudeste BR, credenciais mock
- [ ] Criar VPC com três tiers: pública (load balancers), privada (API) e isolada (banco sem rota internet)
- [ ] Criar security groups encadeados: banco só aceita porta do banco via SG da API
- [ ] Garantir que a porta do banco nunca abre para a internet
- [ ] Criar bucket privado com bloqueio total de acesso público
- [ ] Subir emulador local de nuvem com serviços de computação e storage
- [ ] Validar workflow declarativo: init → validate → apply → plan sem drift

## O que aprender

- [ ] Sintaxe HCL, estado e detecção de drift
  - https://developer.hashicorp.com/terraform/docs
  - https://developer.hashicorp.com/terraform/cli/commands/plan
- [ ] VPC, subnets, route tables e security groups na AWS
  - https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
  - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html
- [ ] S3 e bloqueio de acesso público
  - https://docs.aws.amazon.com/s3/
- [ ] Integração Terraform com emulador local
  - https://docs.localstack.cloud/user-guide/integrations/terraform/

## Critério de pronto

- Plan final com exit 0 (sem mudanças pendentes após apply)
- Banco inalcançável da internet, só via SG da API
- Bucket 100% privado
- Sei explicar por que 3 tiers e não rede única

---

**Prev:** [[02-docker-compose]]
**Next:** [[06-secrets-hygiene]]
**Board:** [[BOARD]]
