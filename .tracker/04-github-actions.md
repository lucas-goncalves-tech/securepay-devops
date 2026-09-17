---
aliases: [issue-04, github-actions, stage-04]
tags: [tracker, issue, todo, study-needed]
status: todo
stage: 04
rfc: RFC-004
---

# Issue #04: Esteira de CI/CD com GitHub Actions, Trivy e IaC Gate

## Acceptance Criteria

### AC-1: Workflow e Gatilhos (`.github/workflows/ledger-service-ci.yml`)

- [ ] Gatilhos `push` e `pull_request` para branches `main` e `master`
- [ ] Filtro de caminhos: `app/ledger-service/**` dispara backend; `infra/ledger-service/**` ou `infra/platform/**` dispara IaC gate

### AC-2: Job 1 — Verificação do Backend (`backend-verification`)

- [ ] Ambiente Java 21 LTS com cache Maven (`cache: 'maven'`)
- [ ] Executa `./mvnw clean test` ou `./mvnw verify` no diretório `app/ledger-service`

### AC-3: Job 2 — Build de Contêiner e Varredura de Segurança (`container-security`)

- [ ] Build da imagem Docker usando `app/ledger-service/Dockerfile`
- [ ] Varredura com **Trivy** (`aquasecurity/trivy-action` ou CLI)
- [ ] Falha o job se houver vulnerabilidades `CRITICAL` ou `HIGH`

### AC-4: Job 3 — Validação de Infraestrutura (`terraform-gate`)

- [ ] Service container LocalStack (`localstack/localstack:4.4.0`) porta `4566:4566`, vars: `SERVICES=s3,ec2`, `AWS_DEFAULT_REGION=sa-east-1`
- [ ] `working-directory: infra/ledger-service/terraform`
- [ ] Executa: `terraform fmt -check`, `terraform init`, `terraform validate`, `terraform plan`

### AC-5: Job 4 — Automação FinOps de Staging

- [ ] Gatilho agendado `schedule` (cron noturno, ex: `0 22 * * 1-5`) para desligar staging
- [ ] Gatilho manual `workflow_dispatch` com input `action` (`start` ou `stop`)
- [ ] Pode morar no CI workflow ou em workflow dedicado (`staging-lifecycle.yml`)

### AC-6: Validação Sintática

- [ ] YAML íntegro, indentação correta, executáveis invocados existem

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
