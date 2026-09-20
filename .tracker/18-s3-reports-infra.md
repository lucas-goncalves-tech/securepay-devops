---
aliases: [issue-18, s3-reports-infra]
tags: [tracker, issue, todo, ready-for-agent]
status: todo
trilha: trilha-1-core
prioridade: alta
---

# Issue #18: Infraestrutura S3 para Relatórios Financeiros

## Problem Statement

O app (ledger-service) gera relatórios financeiros (PDF/CSV) e precisa salvá-los em storage persistente. A infra atual (#03) cria o bucket `securepay-financial-reports` no LocalStack, mas não expõe:
- IAM user com credenciais para o app acessar o S3
- Endpoint S3 acessível da rede do app (subnet privada)
- Contrato do que o app espera da infra (ReportRepository)

O app **já possui** (ou terá) `ReportRepository` com duas implementações:
- `NoOpReportRepository` — default, sem storage real
- `S3ReportRepository` — usa AWS SDK para S3

O objetivo desta issue é **criar a infraestrutura** que torna o `S3ReportRepository` funcional, sem modificar código do app.

## Solution

Criar os recursos Terraform necessários para o app acessar S3:
1. IAM user com política de acesso ao bucket
2. Credenciais expostas via variáveis de ambiente
3. Endpoint S3 acessível da subnet privada (onde roda o app)
4. Security Group allowendo tráfego S3 da subnet privada

## User Stories

1. As a platform engineer, I want an IAM user with scoped S3 permissions, so that the app can read/write reports without broad AWS access
2. As a platform engineer, I want the IAM credentials available as environment variables, so that the app can authenticate to S3 without hardcoding secrets
3. As a platform engineer, I want the S3 endpoint reachable from the private subnet, so that the app can access S3 without public internet exposure
4. As a backend developer, I want to know the bucket name and region via environment variables, so that I can configure the S3 client without hardcoded values
5. As a platform engineer, I want the bucket to block all public access, so that financial reports are never exposed publicly
6. As a platform engineer, I want to test S3 integration locally via LocalStack, so that I can validate the infra before deploying to real AWS
7. As a backend developer, I want a clear contract (environment variables, endpoint), so that I can implement S3ReportRepository without guessing infra details
8. As a platform engineer, I want the IAM policy to allow only the specific bucket, so that the app cannot access other S3 resources
9. As a platform engineer, I want server-side encryption enabled on the bucket, so that reports are encrypted at rest
10. As a platform engineer, I want bucket versioning enabled, so that accidental overwrites can be recovered

## Implementation Decisions

### Resources Terraform

- **IAM User**: `securepay-reports-user` com política S3 scoped ao bucket `securepay-financial-reports`
- **IAM Policy**: `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject` no bucket específico
- **Bucket**: reusar `securepay-financial-reports` já declarado no #03
- **Bucket Config**: `block_public_acls=true`, `block_public_policy=true`, `ignore_public_acls=true`, `restrict_public_buckets=true`, versioning enabled, server-side encryption (AES256)
- **Endpoint**: S3 endpoint já existe no provider (#03). Verificar se é acessível da subnet privada via route table

### Variáveis de Ambiente para o App

O app espera as seguintes variáveis (contrato):

| Variável | Descrição | Exemplo |
|----------|-----------|---------|
| `AWS_ACCESS_KEY_ID` | IAM user access key | `AKIA...` |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key | `wJal...` |
| `AWS_REGION` | Região S3 | `sa-east-1` |
| `S3_BUCKET_NAME` | Nome do bucket | `securepay-financial-reports` |
| `S3_ENDPOINT_URL` | Endpoint (LocalStack only) | `http://localhost:4566` |

### Segurança

- IAM policy com `Effect: Allow` apenas no bucket específico (não `*`)
- Bucket com 4 bloqueios de acesso público (já existente no #03)
- Server-side encryption habilitado
- Credenciais via variáveis de ambiente, nunca em código

### LocalStack vs AWS

| Aspecto | LocalStack | AWS Real |
|---------|------------|----------|
| Endpoint | `http://localhost:4566` | `https://s3.sa-east-1.amazonaws.com` |
| IAM | Credenciais mock (`test/test`) | IAM user real |
| Custo | $0 | ~$0.023/GB armazenamento |

## Testing Decisions

- **Terraform validate**: `terraform init && terraform validate` deve passar
- **Terraform plan**: `terraform plan -detailed-exitcode` deve retornar exit 0 (sem drift)
- **LocalStack**: bucket acessível via `awslocal s3 ls`
- **IAM**: credenciais funcionam para put/get/delete no bucket
- **Segurança**: bucket não aceita acesso público (testar com `awslocal s3api get-bucket-acl`)

## Out of Scope

- **Código do app**: não modificar `ReportRepository`, `S3ReportRepository` ou qualquer Java code
- **Geração de relatórios**: quem gera o conteúdo (PDF/CSV) é decidido pelo app, não pela infra
- **Backups de banco**: são cobertos pelo issue #16
- **ALB/Load Balancer**: coberto pelo issue #03 Etapa 5
- **CI/CD para S3**: coberto pelo issue #04

## Further Notes

- O bucket `securepay-financial-reports` já está declarado no `infra/vpc.tf` (ou deve ser movido para `infra/s3.tf` para organização)
- A política IAM deve ser o mais restritiva possível (least privilege)
- Em produção (AWS real), o app pode usar IAM Roles se rodar em EC2/ECS, mas para LocalStack precisamos de access keys

---

**Prev:** [[17-cicd-vps-deploy]]
**Next:** [[BOARD]]
**Board:** [[BOARD]]
