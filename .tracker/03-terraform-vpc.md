---
aliases: [issue-03, terraform-vpc, stage-03]
tags: [tracker, issue, todo, study-needed]
status: todo
stage: 03
rfc: RFC-003
---

# Issue #03: Infraestrutura como Código (IaC) com Terraform e LocalStack

## Acceptance Criteria

- [ ] Provider AWS para LocalStack (`provider.tf`)
- [ ] VPC Multi-Tier Declarativa (`vpc.tf`)
- [ ] Segurança de Rede com Security Groups Encadeados (`security_groups.tf`)
- [ ] Bucket S3 Privado com Bloqueio de Acesso (`s3.tf`)
- [ ] Orquestração da Nuvem Local (LocalStack)
- [ ] Inicialização e Validação do Terraform
- [ ] Aplicação Inicial do Estado
- [ ] Auditoria de Drift no Terminal

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
