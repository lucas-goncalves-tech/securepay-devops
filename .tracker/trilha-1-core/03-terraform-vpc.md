---
aliases: [issue-03, terraform-vpc, stage-03]
tags: [tracker, issue, done, study-needed]
status: done
trilha: trilha-1-core
prioridade: alta
---

# Issue #03: Infraestrutura como Código com Terraform, VPC Multi-Tier, Roteamento e ALB

## Objetivo

Declarar rede, roteamento, storage e load balancer de forma idempotente em ambiente local compatível com AWS, com banco isolado e tráfego externo roteado via ALB. Separar claramente o que é validado no laboratório LocalStack do que é necessário para uma arquitetura AWS real.

## Contexto e limitações do ambiente

- Provider `hashicorp/aws` `~> 5.0`, região `sa-east-1`, endpoints `s3` e `ec2` apontando para `http://localhost:4566`.
- Credenciais mock com `skip_credentials_validation` e `skip_requesting_account_id`.
- O LocalStack free não oferece `elbv2`; portanto, o ALB está implementado no código, mas **comentado/desativado** no ambiente atual.
- Sucesso de `init`, `validate`, `plan` e `apply` prova que os recursos declarados foram aceitos pelo emulador; **não prova** que toda a semântica de rede, roteamento e segurança da AWS real foi reproduzida.
- Objetivo do laboratório: aprender e validar arquitetura sem custos reais.

## Estado atual do código

| Arquivo | Conteúdo atual | Observação |
|---|---|---|
| `infra/provider.tf` | Provider AWS + LocalStack, endpoints `s3`/`ec2` | Endpoint `elbv2` está comentado |
| `infra/vpc.tf` | VPC, três subnets, IGW e route tables | ALB comentado; `aws_internet_gateway` e route tables **já implementados** |
| `infra/security.tf` | SG da API e SG do banco | SG do ALB comentado; API exposta temporariamente para o laboratório |
| `infra/s3.tf` | Bucket e quatro bloqueios de acesso público | Adequado ao escopo desta issue |

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
- [x] Criar subnet pública `10.0.1.0/24` (load balancers), privada `10.0.2.0/24` (API) e isolada `10.0.3.0/24` (destinada ao banco)
- [x] Confirmar o comportamento de rota isolado da subnet do banco na Etapa 2B

**FIM:** três tiers endereçados e segregados por CIDR; isolamento por rota fica explícito na Etapa 2B.

---

### Etapa 2B — Roteamento explícito

**INÍCIO:** subnets existem, mas ainda não há definição explícita de caminho para internet.

- [x] Declarar `aws_internet_gateway` associado à VPC
- [x] Criar route table pública com rota padrão `0.0.0.0/0` para o Internet Gateway
- [x] Associar a subnet pública à route table pública
- [x] Criar route table privada para a subnet da API, sem rota padrão direta para o Internet Gateway
- [x] Criar ou reutilizar route table sem rota internet para a subnet do banco
- [x] Associar explicitamente cada subnet à sua route table
- [x] Garantir que a subnet do banco não tenha rota direta para a internet

**FIM:** cada subnet tem um comportamento de rota explícito:

```text
subnet pública → Internet Gateway
subnet API     → sem rota internet direta
subnet banco   → sem rota internet direta
```

> **Nota:** o LocalStack pode não validar toda a semântica de rota. Mesmo assim, as rotas devem ser declaradas para que o desenho seja fiel à arquitetura pretendida.

---

### Etapa 3 — Segurança e storage

**INÍCIO:** rede existe, mas banco pode estar exposto.

- [x] Criar SG da API e SG do banco
- [x] Criar entrada `5432` no SG do banco exclusivamente a partir do SG da API; nunca `0.0.0.0/0`
- [x] Criar bucket `securepay-financial-reports` com os 4 bloqueios (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`)
- [ ] Quando o ALB estiver ativo, restringir a entrada da API à porta `8080` exclusivamente pelo SG do ALB

**Nota do laboratório:** enquanto o ALB está desativado no LocalStack free, o código atual mantém uma entrada temporária da API para testes. Essa regra não deve ser confundida com o desenho final de produção.

**FIM:** banco só via SG da API; bucket 100% privado; exposição da API documentada e restrita quando o ALB estiver ativo.

---

### Etapa 4 — Apply sem drift

**INÍCIO:** código pronto, estado não aplicado.

- [x] Executar `init` → `validate` → `apply -auto-approve` → `plan -detailed-exitcode` com exit 0
- [x] Repetir `plan -detailed-exitcode` após adicionar route tables, Internet Gateway ou quaisquer novos recursos

**FIM:** plan final exit 0, sem pendências.

---

### Etapa 5 — Load Balancer

**Status:** implementado no código e **desativado no LocalStack free** por indisponibilidade de `elbv2`.

- [x] Reservar endpoint `elbv2` no `provider.tf`, mantendo-o comentado enquanto o LocalStack free não suportar o serviço
- [x] Declarar ALB (Application Load Balancer) na subnet pública, com recursos comentados no ambiente atual
- [x] Declarar Target Group apontando para API na subnet privada (porta `8080`)
- [x] Declarar Listener na porta `80` com forward para Target Group
- [x] Configurar health check no Target Group (path: `/actuator/health`)
- [x] Declarar SG do ALB com entrada porta `80` (HTTP), mantendo-o comentado no ambiente atual
- [x] Definir que a API deve aceitar tráfego exclusivamente do SG do ALB quando o ALB estiver ativo
- [ ] Reativar os recursos em um ambiente com suporte a `elbv2` e validar DNS, listener e health check

**FIM com ALB habilitado:** ALB roteia tráfego para API via Target Group; health check passando.

**FIM no LocalStack free:** recursos preservados no código, comentados e documentados; ausência de ALB não bloqueia o laboratório das Etapas 1–4.

## O que aprender

### Aprender A — Terraform base

- [x] HCL, estado e drift
  - https://developer.hashicorp.com/terraform/docs
  - https://developer.hashicorp.com/terraform/cli/commands/plan

**FIM:** sei explicar idempotência e drift.

---

### Aprender B — Rede e storage AWS

- [x] VPC, subnets, route tables, SGs
  - https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
  - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html
  - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-route-tables.html
- [x] Internet Gateway e diferença entre subnet pública e privada
- [x] S3 e bloqueio público
  - https://docs.aws.amazon.com/s3/

**FIM:** sei justificar 3 tiers, rota de cada subnet e SG encadeado.

---

### Aprender D — Load Balancer

- [ ] ALB vs NLB vs GLB, Target Groups e health checks
  - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html
  - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
- [x] Security Groups encadeados (ALB → API → DB)
  - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html

**FIM:** sei justificar quando usar ALB vs NLB; health check configurado.

---

### Aprender C — Emulador local

- [x] Integração com Terraform
  - https://docs.localstack.cloud/user-guide/integrations/terraform/
- [x] O que o LocalStack free cobre e o que ele simplifica em relação à AWS real

**FIM:** sei apontar endpoint e serviços emulados, e separar validação local de prontidão para produção.

## Critério de pronto

### Laboratório LocalStack

1. [x] `plan -detailed-exitcode` exit 0
2. [x] `5432` jamais em `0.0.0.0/0`
3. [x] Bucket privado com 4 bloqueios; VPC e subnets exatas
4. [x] ALB implementado no código e desativado/documentado no LocalStack free
5. [x] Limitação de roteamento local documentada ou route tables implementadas

### Arquitetura final

1. [x] Subnet pública associada a route table com rota para Internet Gateway
2. [x] Subnets da API e do banco sem rota internet direta
3. [ ] SG da API aceita `8080` somente do SG do ALB quando o ALB estiver ativo
4. [ ] ALB acessível via DNS público em ambiente com `elbv2`
5. [ ] Health check do Target Group passando (`target healthy`)

## Carry-over

**Status:** Done para o laboratório LocalStack (critérios de laboratório 100% concluídos). Os itens abaixo ficaram em aberto e são **condicionados a um ambiente com `elbv2`** — nenhum deles bloqueia a execução da issue #04:

- [ ] Reativar `aws_alb`, `aws_alb_target_group` e `aws_alb_listener` (hoje comentados em `vpc.tf`), e validar DNS, listener e health check
- [ ] Restringir a entrada da API na porta `8080` ao SG do ALB — enquanto isso, a regra temporária de `0.0.0.0/0` em `80`/`443` permanece documentada como lab-only
- [ ] **Aprender D** — ALB vs NLB vs GLB

Nota sobre o `elbv2`: `infra/platform/compose-localstack.yaml` já lista `elbv2` em `SERVICES` e exige `LOCALSTACK_AUTH_TOKEN`. Se o ambiente agora é Pro, a premissa "free tier não tem elbv2" do texto original está defasada e vale reavaliar a reativação.

## Fora de escopo

- Proibido: Kubernetes, Helm, CloudWatch Logs avançado, EKS, esteiras de CI/CD
- Foco exclusivo: HCL, provider local em `localhost:4566`, VPC multi-tier, roteamento explícito, SGs sem vazamento em `5432`, bucket privado, drift via `plan` e ALB com target group e health check
- NAT Gateway, TLS/HTTPS no ALB, WAF, Multi-AZ e backup: fora desta issue, salvo decisão explícita posterior

---

**Prev:** [[02-docker-compose]]
**Next:** [[04-s3-reports-infra]]
**Board:** [[BOARD]]
