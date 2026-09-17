# ⚙️ Estágio 04: Esteira de CI/CD com GitHub Actions, Trivy e IaC Gate

> **RFC-004:** Pipeline Automatizada de Integração Contínua com Portões de Qualidade e Segurança.  
> **Objetivo Técnico:** Automatizar testes de regressão de software, varredura estática de vulnerabilidades (CVEs) em imagens de contêineres e validação sintática de infraestrutura antes do merge.

---

## 🎯 Contexto do Problema

Processos de entrega manuais (como transferências via SSH ou deploys manuais) causam falhas frequentes em produção:
1. **Regressões não detectadas:** Código com testes quebrados integrado à branch principal porque os desenvolvedores deixaram de rodar a suíte localmente.
2. **Imagens vulneráveis promovidas para produção:** Imagens Docker contendo pacotes desatualizados com vulnerabilidades críticas conhecidas (CVEs) publicadas sem auditoria prévia.
3. **Erros de sintaxe em infraestrutura:** Pull Requests com arquivos Terraform quebrados que interrompem o provisionamento durante o deploy.

Neste estágio, você vai criar o pipeline corporativo de CI/CD no **GitHub Actions** (`.github/workflows/ledger-service-ci.yml`), implementando o conceito de *Shift-Left Security* com portões determinísticos de aprovação.

---

## 📋 Critérios de Aceite

> Cada item abaixo é um checkbox independente que espelha uma asserção do oráculo (`verify.py`). Abra o accordion só da task atual.

- [x] **Workflow e gatilhos (`.github/workflows/ledger-service-ci.yml` ou `ci.yml`):**
  <details>
  <summary>ver detalhes</summary>

  - Gatilhos de `push` e `pull_request` para as branches `main` e `master`.
  - Filtro de caminhos (`paths` ou `paths-filter`): alterações em `app/ledger-service/**` disparam a verificação de backend/contêiner; alterações em `infra/ledger-service/**` ou `infra/platform/**` disparam o gate de IaC.

  </details>

- [x] **Job 1: Verificação do Backend (`backend-verification`):**
  <details>
  <summary>ver detalhes</summary>

  - Ambiente com Java 21 LTS e cache de dependências Maven (`cache: 'maven'`).
  - Suíte de testes da aplicação (`./mvnw clean test` ou `./mvnw verify`) sob o diretório `app/ledger-service`.

  </details>

- [ ] **Job 2: Build de Contêiner e Varredura de Segurança (`container-security`):**
  <details>
  <summary>ver detalhes</summary>

  - Build da imagem Docker utilizando `app/ledger-service/Dockerfile`.
  - Varredura da imagem com **Trivy** (via action `aquasecurity/trivy-action` ou script CLI).
  - A esteira falha o job se houver vulnerabilidades de severidade `CRITICAL` ou `HIGH`.

  </details>

- [ ] **Job 3: Validação de Infraestrutura & Simulação IaC (`terraform-gate`):**
  <details>
  <summary>ver detalhes</summary>

  - Service container do **LocalStack** (`localstack/localstack:4.4.0`) mapeando a porta `4566:4566`, com variáveis mínimas (`SERVICES=s3,ec2`, `AWS_DEFAULT_REGION=sa-east-1`).
  - Com `working-directory: infra/ledger-service/terraform`, executar: `terraform fmt -check`, `terraform init`, `terraform validate` e `terraform plan` contra o LocalStack.

  </details>

- [ ] **Job 4: Automação FinOps de Ambientes de Staging (`staging-cost-optimizer` ou `staging-lifecycle.yml`):**
  <details>
  <summary>ver detalhes</summary>

  - **Cenário Real de Negócio (FinOps no Dia a Dia):** Recursos de homologação e testes (staging) ligados 24/7 geram mais de 60% de desperdício em faturas cloud quando o time não está trabalhando.
  - Configurar gatilho agendado com **`schedule`** (cron noturno, ex: `0 22 * * 1-5` ou similar) para desligar ou pausar os contêineres/ambientes de staging.
  - Configurar gatilho manual com **`workflow_dispatch`** aceitando inputs (`action`: `start` ou `stop`) para que desenvolvedores possam reativar ou pausar o ambiente sob demanda para testes.
  - Pode morar dentro de `.github/workflows/ledger-service-ci.yml` ou em um workflow dedicado como `.github/workflows/staging-lifecycle.yml`.

  </details>

- [ ] **Validação Sintática e Coerência Local:**
  <details>
  <summary>ver detalhes</summary>

  - Integridade do arquivo YAML, indentação correta dos blocos e existência dos executáveis invocados.

  </details>

---

## 🚧 Fronteira de Não-Escopo

- ❌ **Proibido Cobrar:** Kubernetes GitOps (ArgoCD/Flux), AWS ECS Fargate deploy, Ansible.
- ✅ **Foco Exclusivo:** Workflow YAML no GitHub Actions, build e testes Maven (`./mvnw verify`), build da imagem Docker, escaneamento de vulnerabilidades estáticas com Trivy (`trivy image --severity HIGH,CRITICAL`), e validação de sintaxe Terraform (`terraform fmt` e `validate`).

---

## 📚 Documentação de Referência
- [Building and Testing Java with Maven in GitHub Actions](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-java-with-maven)
- [Aqua Security Trivy Action Documentation](https://github.com/aquasecurity/trivy-action)
- [Automating Terraform with GitHub Actions](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)

---

## ⚖️ Validação Mecânica (Oráculo)
Para validar os critérios deste estágio, execute no terminal:
```bash
python3 stages-labs/spring-cloud-platform/04-github-actions/verify.py
```
O estágio é considerado concluído quando todas as asserções retornarem `PASS` e o Exit Code for `0`.
