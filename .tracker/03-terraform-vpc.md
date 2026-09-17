---
aliases: [issue-03, terraform-vpc, stage-03]
tags: [tracker, issue, todo, study-needed]
status: todo
stage: 03
rfc: RFC-003
---

# Issue #03: Infraestrutura como Código (IaC) com Terraform e LocalStack

## Acceptance Criteria

### AC-1: Provider AWS para LocalStack (`infra/ledger-service/terraform/provider.tf`)

- [ ] Provider `hashicorp/aws` versão `~> 5.0`
- [ ] Endpoints (`ec2`, `s3`) redirecionados para `http://localhost:4566`
- [ ] Região `sa-east-1`, credenciais de emulação (`mock_key`/`mock_secret` ou `test`)
- [ ] `skip_credentials_validation = true` e `skip_requesting_account_id = true`

### AC-2: VPC Multi-Tier (`infra/ledger-service/terraform/vpc.tf`)

- [ ] `aws_vpc` com CIDR `10.0.0.0/16`
- [ ] **Sub-rede Pública** `10.0.1.0/24` — entrada para load balancers
- [ ] **Sub-rede Privada** `10.0.2.0/24` — execução da API `ledger-service`
- [ ] **Sub-rede de Dados Isolada** `10.0.3.0/24` — banco PostgreSQL, sem rota para internet

### AC-3: Security Groups Encadeados (`infra/ledger-service/terraform/security_groups.tf`)

- [ ] SG da API: permite entrada HTTP na porta `8080`
- [ ] SG do banco: permite entrada na porta `5432` **exclusivamente** originada pelo SG da API (`security_groups = [aws_security_group.<api_sg>.id]`)
- [ ] **Proibido:** porta `5432` associada a `0.0.0.0/0` ou blocos CIDR amplos

### AC-4: Bucket S3 Privado (`infra/ledger-service/terraform/s3.tf`)

- [ ] `aws_s3_bucket` nome `securepay-financial-reports`
- [ ] `aws_s3_bucket_public_access_block` com todos os bloqueios: `block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`

### AC-5: Orquestração LocalStack

- [ ] LocalStack rodando via `docker compose -f infra/platform/localstack/docker-compose.yml up -d`
- [ ] Endpoint `http://localhost:4566` responde com sucesso

### AC-6: Inicialização e Validação do Terraform

- [ ] `terraform init` no diretório `infra/ledger-service/terraform/`
- [ ] `terraform validate` passa sem erros

### AC-7: Aplicação Inicial do Estado

- [ ] `terraform apply -auto-approve` provisiona a topologia no LocalStack

### AC-8: Auditoria de Drift

- [ ] `terraform plan -detailed-exitcode` retorna Exit Code 0 (sem alterações pendentes)

## Scope

- Terraform HCL, AWS Provider local (`localhost:4566`), VPC `10.0.0.0/16` with public/private/isolated subnets, Security Groups without port 5432 leakage, private S3 bucket, empirical drift detection (`terraform plan`)
- **Out of scope:** Kubernetes, Helm, CloudWatch Logs, AWS EKS, CI/CD pipelines

## Study Needed

- [ ] Terraform AWS VPC Resource
- [ ] Terraform AWS Security Group Rules
- [ ] LocalStack Terraform Integration
- [ ] HCL syntax and state management

## References

- [Terraform AWS VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Terraform AWS Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- [LocalStack Terraform Guide](https://docs.localstack.cloud/user-guide/integrations/terraform/)

## Validation

```bash
python3 stages-labs/spring-cloud-platform/03-terraform-vpc/verify.py
```

---

**Prev:** [[02-docker-compose]]
**Next:** [[04-github-actions]]
**Board:** [[BOARD]]
