# 🌐 Estágio 03: Infraestrutura como Código (IaC) com Terraform e LocalStack

> **RFC-003:** Arquitetura de Rede Multi-Tier e Isolamento de Recursos com AWS Provider.  
> **Objetivo Técnico:** Modelar infraestrutura declarativa em HCL, aplicar o princípio do menor privilégio em regras de firewall L4, emular nuvem localmente e auditar divergências de estado (drift).

---

## 🎯 Contexto do Problema

O provisionamento manual de infraestrutura através de consoles web gera riscos operacionais graves:
1. **Bancos de dados expostos à internet pública:** Instâncias com regras de Security Group permitindo `0.0.0.0/0` na porta 5432 ou alocadas em sub-redes com rota direta para a internet.
2. **Ambientes não reprodutíveis e Cloud Drift:** Falta de rastreabilidade sobre como o ambiente foi criado, impossibilitando recriá-lo de forma consistente em caso de desastre.
3. **Armazenamento de relatórios desprotegido:** Buckets S3 contendo dados confidenciais criados sem bloqueio explícito de acesso público.

Neste estágio, você vai codificar a topologia corporativa da SecurePay em **Terraform HCL**, apontando os recursos para um ambiente local emulado pelo **LocalStack** (`http://localhost:4566`) na região **`sa-east-1` (São Paulo)**, garantindo custo zero, conformidade com a soberania de dados (LGPD) e iteração rápida.

---

## 📋 Critérios de Aceite

> Cada item abaixo é um checkbox independente que espelha uma asserção do oráculo (`verify.py`). Abra o accordion só da task atual.

- [x] **Configuração do Provider AWS para LocalStack (`infra/ledger-service/terraform/provider.tf`):**
  <details>
  <summary>ver detalhes</summary>

  - Declarar o provider `hashicorp/aws` sob versão `~> 5.0`.
  - Redirecionar os endpoints de serviços (`ec2` e `s3`) para `http://localhost:4566`.
  - Definir a região oficial `sa-east-1` e credenciais de emulação (`mock_key` / `mock_secret` ou `test`).
  - Habilitar `skip_credentials_validation` e `skip_requesting_account_id`.

  </details>

- [x] **VPC Multi-Tier Declarativa (`infra/ledger-service/terraform/vpc.tf`):**
  <details>
  <summary>ver detalhes</summary>

  - Provisionar recurso `aws_vpc` com bloco CIDR `10.0.0.0/16`.
  - Criar três sub-redes distintas (`aws_subnet`) segregando os níveis da aplicação:
    * **Sub-rede Pública (`10.0.1.0/24`):** Camada de entrada para balanceadores de tráfego.
    * **Sub-rede Privada (`10.0.2.0/24`):** Camada de execução da API `ledger-service`.
    * **Sub-rede de Dados Isolada (`10.0.3.0/24`):** Camada do banco PostgreSQL, sem rota para a internet.

  </details>

- [x] **Segurança de Rede com Security Groups Encadeados (`infra/ledger-service/terraform/security_groups.tf`):**
  <details>
  <summary>ver detalhes</summary>

  - Criar o Security Group da API (`aws_security_group.securepay_ledger_app` ou similar): permite entrada de tráfego HTTP na porta `8080`.
  - Criar o Security Group do banco (`aws_security_group.securepay_db` ou similar): permite entrada na porta `5432` **exclusivamente originada pelo Security Group da API**, utilizando `security_groups = [aws_security_group.<api_sg>.id]`.
  - **Regra Rígida de Segurança:** É proibido associar a porta `5432` a `0.0.0.0/0` ou a blocos CIDR amplos.

  </details>

- [x] **Bucket S3 Privado com Bloqueio de Acesso (`infra/ledger-service/terraform/s3.tf`):**
  <details>
  <summary>ver detalhes</summary>

  - Criar o recurso `aws_s3_bucket` com o nome `securepay-financial-reports`.
  - Associar o recurso `aws_s3_bucket_public_access_block` habilitando todos os bloqueios de segurança (`block_public_acls`, `block_public_policy`, `ignore_public_acls` e `restrict_public_buckets`).

  </details>

- [x] **Orquestração da Nuvem Local (LocalStack):**
  <details>
  <summary>ver detalhes</summary>

  - Subir a infraestrutura emulada com `docker compose -f infra/platform/localstack/docker-compose.yml up -d` (ou fallback na raiz).
  - Garantir que o endpoint `http://localhost:4566` responda com sucesso.

  </details>

- [x] **Inicialização e Validação do Terraform:**
  <details>
  <summary>ver detalhes</summary>

  - Executar `terraform init` no diretório `infra/ledger-service/terraform/` para sincronizar os plugins e o `.terraform.lock.hcl`.
  - Executar `terraform validate` para confirmar a integridade estática e referências do grafo.

  </details>

- [x] **Aplicação Inicial do Estado:**
  <details>
  <summary>ver detalhes</summary>

  - Executar `terraform apply -auto-approve` no diretório `infra/ledger-service/terraform/` para provisionar a topologia no LocalStack.

  </details>

- [x] **Auditoria de Drift no Terminal:**
  <details>
  <summary>ver detalhes</summary>

  - Executar `terraform plan -detailed-exitcode` no diretório `infra/ledger-service/terraform/`.
  - Confirmar que o statefile reflete com precisão os recursos declarados e que não existem alterações pendentes (Exit Code 0).

  </details>

---

## 🚧 Fronteira de Não-Escopo

- ❌ **Proibido Cobrar:** Kubernetes, Helm, CloudWatch Logs avançado, AWS EKS, esteiras de CI/CD.
- ✅ **Foco Exclusivo:** Terraform HCL, Provider AWS local (`localhost:4566`), VPC `10.0.0.0/16` com subnets pública/privada/isolada, Security Groups sem vazamento na porta 5432, Bucket S3 privado e detecção empírica de drift (`terraform plan`).

---

## 🛠️ Guia Operacional de Execução

1. **Subir o LocalStack:**
   ```bash
   docker compose -f infra/platform/localstack/docker-compose.yml up -d
   ```
2. **Inicializar o Workspace Terraform:**
   ```bash
   cd infra/ledger-service/terraform
   terraform init
   terraform validate
   ```
3. **Provisionar a Infraestrutura Local:**
   ```bash
   terraform apply -auto-approve
   ```
4. **Verificar Ausência de Drift:**
   ```bash
   terraform plan -detailed-exitcode
   echo "Exit Code: $?" # Deve ser 0
   ```

---

## 📚 Documentação de Referência
- [Terraform AWS VPC Resource Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Terraform AWS Security Group Rules Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- [LocalStack Terraform Integration Guide](https://docs.localstack.cloud/user-guide/integrations/terraform/)

---

## ⚖️ Validação Mecânica (Oráculo)
Para validar os critérios deste estágio, execute no terminal:
```bash
python3 stages-labs/spring-cloud-platform/03-terraform-vpc/verify.py
```
O estágio é considerado concluído quando todas as asserções retornarem `PASS` e o Exit Code for `0`. Caso o LocalStack esteja offline ou o estado ainda não tenha sido aplicado, o oráculo sinalizará o status `PENDENTE` (Exit Code 2).
