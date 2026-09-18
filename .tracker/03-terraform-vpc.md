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

- [ ] Declarar provider AWS `hashicorp/aws` `~> 5.0` apontando endpoints `ec2` e `s3` para `http://localhost:4566`, região `sa-east-1`, credenciais mock, com `skip_credentials_validation` e `skip_requesting_account_id`
- [ ] Criar VPC `10.0.0.0/16` com três tiers: pública `10.0.1.0/24` (load balancers), privada `10.0.2.0/24` (API) e isolada `10.0.3.0/24` (banco sem rota internet)
- [ ] Criar SG da API com entrada HTTP `8080` e SG do banco com entrada `5432` exclusivamente via SG da API
- [ ] Garantir que a porta `5432` nunca abre para `0.0.0.0/0` ou CIDR amplo
- [ ] Criar bucket `securepay-financial-reports` com bloqueio total (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`)
- [ ] Subir emulador local com `SERVICES=s3,ec2`, região `sa-east-1`, endpoint `http://localhost:4566` respondendo
- [ ] Validar workflow: `init` → `validate` → `apply -auto-approve` → `plan -detailed-exitcode` com exit 0

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

- `plan -detailed-exitcode` com exit 0 (sem mudanças pendentes após apply)
- Banco inalcançável da internet, só via SG da API; `5432` jamais em `0.0.0.0/0`
- Bucket `securepay-financial-reports` 100% privado com os 4 bloqueios ativos
- VPC exata `10.0.0.0/16` com subnets `10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24`
- Sei explicar por que 3 tiers e não rede única

## Fora de escopo

- Proibido: Kubernetes, Helm, CloudWatch Logs avançado, EKS, esteiras de CI/CD
- Foco exclusivo: HCL, provider local em `localhost:4566`, VPC multi-tier, SGs sem vazamento em `5432`, bucket privado e drift via `plan`

---

**Prev:** [[02-docker-compose]]
**Next:** [[06-secrets-hygiene]]
**Board:** [[BOARD]]
