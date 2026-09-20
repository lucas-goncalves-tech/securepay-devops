---
aliases: [issue-03, terraform-vpc, stage-03]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-1-core
prioridade: alta
---

# Issue #03: Infraestrutura como Código com Terraform, VPC Multi-Tier e ALB

## Objetivo

Declarar rede, storage e load balancer de forma idempotente em ambiente local compatível com AWS, com banco isolado e tráfego externo roteado via ALB.

## O que fazer

### Etapa 1 — Provider e emulador

**INÍCIO:** nada declarado, nuvem local fora do ar.

- [x] Declarar provider `hashicorp/aws` `~> 5.0`, endpoints `ec2` e `s3` em `http://localhost:4566`, região `sa-east-1`, credenciais mock, com `skip_credentials_validation` e `skip_requesting_account_id`
- [x] Subir emulador local com `SERVICES=s3,ec2`, região `sa-east-1`, endpoint respondendo

**FIM:** endpoint local responde; `init` e `validate` passam.

---

### Etapa 2 — Rede multi-tier

**INÍCIO:** provider ok, rede única ou inexistente.

- [x] Criar VPC `10.0.0.0/16`
- [x] Criar pública `10.0.1.0/24` (load balancers), privada `10.0.2.0/24` (API) e isolada `10.0.3.0/24` (banco sem rota internet)

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

---

### Etapa 5 — Load Balancer

**INÍCIO:** subnets criadas, API sem entrada externa.

- [ ] Adicionar endpoint `elbv2` no provider.tf
- [ ] Declarar ALB (Application Load Balancer) na subnet pública
- [ ] Criar Target Group apontando para API na subnet privada (porta 8080)
- [ ] Declarar Listener na porta 80 com forward para Target Group
- [ ] Configurar health check no Target Group (path: `/actuator/health`)
- [ ] Criar SG do ALB com entrada porta 80 (HTTP)
- [ ] Ajustar SG da API para aceitar tráfego exclusivamente do SG do ALB

**FIM:** ALB roteando tráfego para API via Target Group; health check passando.

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

### Aprender D — Load Balancer

- [ ] ALB vs NLB vs GLB, Target Groups e health checks
  - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html
  - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
- [ ] Security Groups encadeados (ALB → API → DB)
  - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html

**FIM:** sei justificar quando usar ALB vs NLB; health check configurado.

---

### Aprender C — Emulador local

- [ ] Integração com Terraform
  - https://docs.localstack.cloud/user-guide/integrations/terraform/

**FIM:** sei apontar endpoint e serviços emulados.

## Critério de pronto

1. [ ] `plan -detailed-exitcode` exit 0
2. [ ] `5432` jamais em `0.0.0.0/0`
3. [ ] Bucket privado com 4 bloqueios; VPC e subnets exatas
4. [ ] ALB acessível via DNS público
5. [ ] Health check passando (target healthy)
6. [ ] SG da API só aceita tráfego do SG do ALB

## Fora de escopo

- Proibido: Kubernetes, Helm, CloudWatch Logs avançado, EKS, esteiras de CI/CD
- Foco exclusivo: HCL, provider local em `localhost:4566`, VPC multi-tier, SGs sem vazamento em `5432`, bucket privado, drift via `plan`, ALB com target group e health check

---

**Prev:** [[02-docker-compose]]
**Next:** [[06-secrets-hygiene]]
**Board:** [[BOARD]]
