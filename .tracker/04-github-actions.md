---
aliases: [issue-04, github-actions, stage-04]
tags: [tracker, issue, todo, study-needed]
status: todo
stage: 04
rfc: RFC-004
---

# Issue #04: Esteira de CI/CD com GitHub Actions, Trivy e IaC Gate

## Acceptance Criteria

- [ ] Workflow e gatilhos (`ledger-service-ci.yml`)
- [ ] Job 1: Verificação do Backend (`backend-verification`)
- [ ] Job 2: Build de Contêiner e Varredura de Segurança (`container-security`)
- [ ] Job 3: Validação de Infraestrutura & Simulação IaC (`terraform-gate`)
- [ ] Job 4: Automação FinOps de Ambientes de Staging
- [ ] Validação Sintática e Coerência Local

## Scope

- GitHub Actions workflow YAML, Maven build/test (`./mvnw verify`), Docker image build, Trivy vulnerability scanning (`trivy image --severity HIGH,CRITICAL`), Terraform syntax validation (`terraform fmt` and `validate`)
- **Out of scope:** Kubernetes GitOps (ArgoCD/Flux), AWS ECS Fargate deploy, Ansible

## Study Needed

- [ ] Building and Testing Java with Maven in GitHub Actions
- [ ] Aqua Security Trivy Action
- [ ] Automating Terraform with GitHub Actions
- [ ] GitHub Actions workflow syntax

## References

- [Building and Testing Java with Maven](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-java-with-maven)
- [Trivy Action](https://github.com/aquasecurity/trivy-action)
- [Automating Terraform with GitHub Actions](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)

## Validation

```bash
python3 stages-labs/spring-cloud-platform/04-github-actions/verify.py
```

---

**Prev:** [[03-terraform-vpc]]
**Next:** [[05-observability]]
**Board:** [[BOARD]]
