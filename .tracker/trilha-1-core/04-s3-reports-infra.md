---
aliases: [issue-04, s3-reports-infra]
tags: [tracker, issue, doing, study-needed]
status: doing
trilha: trilha-1-core
prioridade: alta
---

# Issue #04: Infraestrutura S3 para Relatórios Financeiros

## Objetivo

Dar ao app storage persistente para relatórios financeiros (PDF/CSV): identidade IAM com least privilege, endpoint de rede privada para o S3 e contrato de variáveis de ambiente — tornando o `S3ReportRepository` funcional sem modificar código do app.

## Ordem de execução

O card é percorrido nesta ordem, não na numérica das Etapas:

`Etapa 1 (ambiente + IAM) → Etapa 3 (bucket + contrato) → Etapa 4 (validação) → Etapa 2 (endpoint de rede)`

A Etapa 2 vem por último: depende do route table do #03 e é a que exige a nota de `lab ≠ real`.

---

## O que fazer

### Etapa 1 — Identidade IAM com least privilege

**INÍCIO:** o bucket existe (#03), mas ninguém tem permissão para usá-lo — e o emulador nem expõe o serviço IAM.

#### 1A — Liberar o IAM nos dois lados do contrato

**INÍCIO:** `provider.tf` e o compose só falam de `s3` e `ec2`.

- [ ] Em `infra/provider.tf`, adicionar `iam = "http://localhost:4566"` ao bloco `endpoints { }`
- [ ] Em `infra/platform/compose-localstack.yaml`, adicionar `iam` à variável `SERVICES` (hoje: `s3,ec2,elbv2`)
- [ ] No mesmo arquivo, adicionar `ENFORCE_IAM=1` ao bloco `environment`
- [ ] Reiniciar o emulador (`docker compose up -d`) — `SERVICES` só é lido no boot
- [ ] Conferir que a janela de dois lados bate: o `endpoints { }` do Terraform precisa listar exatamente os serviços que o `SERVICES=` inicializou

**FIM:** `awslocal iam list-users` responde, em vez de `Unknown operation`.

#### 1B — Identidade para o app

**INÍCIO:** o serviço IAM responde, mas nenhum principal existe.

- [ ] Declarar IAM **Role** (não User) com `assume_role_policy` para o principal que vai rodar o app
- [ ] Declarar `aws_iam_policy` com `Effect: Allow` apenas para `s3:PutObject`, `s3:GetObject` e `s3:DeleteObject` no ARN de `securepay-financial-reports` — nunca `Resource: "*"`
- [ ] Associar a policy à Role via `aws_iam_role_policy_attachment`
- [ ] Anotar no comentário do arquivo: no laboratório LocalStack a Role não é assumida por nenhuma instância real, porque não há instância — ela é declarada para o desenho ser fiel

**Por que Role e não User:** um User gera access key fixa que alguém precisa guardar. Em AWS real, um container na VPC veste uma Role e o próprio AWS entrega credencial temporária. Ver **Aprender A**.

**FIM:** Role + policy declaradas e associadas; `terraform validate` passa.

#### 1C — Prova de least privilege (com a ressalva do emulador)

**INÍCIO:** política declarada, nada testado.

- [ ] Criar um User descartável **só** para a prova, com a mesma policy — artefato de laboratório, não o entregável
- [ ] Exportar as access keys desse User no shell e fazer `awslocal s3api put-object` no bucket → **esperado: sucesso**
- [ ] Repetir o put contra um bucket que não é o alvo → **esperado: `AccessDenied`**
- [ ] Repetir com `get-object` no bucket alvo → **esperado: sucesso**
- [ ] Guardar o resultado de `delete-object` **fora** do alvo: o LocalStack tem `s3:DeleteObject` sem cobertura de negação testada, então esse resultado não prova nada

> **Ressalva obrigatória:** `ENFORCE_IAM` é feature **Pro** e está desabilitada por padrão. Sem ela, "todas as APIs são acessíveis sem autenticação". Se a 1C não negar nada, o cenário correto é rebaixar esta Etapa para "declarar e inspecionar a policy" e marcar a prova de negação como **bloqueada por ambiente**, não como falha.

**FIM:** `Put` e `Get` provam o allow e o deny no bucket alvo; a ressalva está registrada.

---

### Etapa 3 — Bucket e contrato com o app

**INÍCIO:** bucket básico criado no #03, sem proteções de conteúdo nem contrato publicado.

- [ ] Reusar o bucket `securepay-financial-reports` já declarado em `infra/s3.tf`
- [ ] Declarar `aws_s3_bucket_versioning` (recurso próprio no provider `aws` v5 — a bandeira não existe mais dentro do `aws_s3_bucket`)
- [ ] Declarar `aws_s3_bucket_server_side_encryption_configuration` com `sse_algorithm = "AES256"`
- [ ] Declarar `aws_s3_bucket_lifecycle_rule` expirando versões antigas — **obrigatório**: com versioning ligado, um `deleteObject` vira *delete marker* e o objeto anterior continua faturando. Sem expiração, o bucket nunca encolhe
- [ ] Publicar o contrato de variáveis que o app **realmente lê** (auditado em `application.yml:56-60`):
  - `S3_ENABLED` — `true` liga o `S3ReportRepository`; sem ela o `NoOpReportRepository` fica ativo e as outras três não fazem nada
  - `S3_BUCKET_NAME` — `securepay-financial-reports`
  - `AWS_REGION` — `sa-east-1`
  - `S3_ENDPOINT_URL` — `http://localhost:4566` (lab); vazio na AWS real, que usa o endpoint regional
- [ ] Registrar como **nota**, não como variável: `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` **não são lidas em lugar nenhum do backend** (grep vazio). `S3Config.java:26-30` injeta `"test"/"test"` fixo quando há endpoint, e só quando `S3_ENDPOINT_URL` está vazia é que a cadeia padrão do SDK entra. Servem para a prova manual da Etapa 1C, não para o app

**FIM:** app configurável 100% pelas 4 env vars, sem hardcode; bucket versionado, criptografado e com retenção de versões.

---

### Etapa 4 — Validação determinística

**INÍCIO:** recursos declarados, nada validado.

- [ ] `terraform init && terraform validate` passam
- [ ] `terraform plan -detailed-exitcode` retorna exit 0 (sem drift)
- [ ] `awslocal s3 ls` acessa o bucket
- [ ] Put/get via as credenciais do User descartável da Etapa 1C funcionam no bucket alvo
- [ ] `awslocal s3api get-bucket-acl` e `get-bucket-public-access-block` confirmam zero acesso público
- [ ] `awslocal s3api get-bucket-versioning` e `get-bucket-encryption` confirmam versioning + AES256

**FIM:** tudo validado por comando determinístico, nada manual.

---

### Etapa 2 — Endpoint de rede privada

**INÍCIO:** não existe nenhum `aws_vpc_endpoint` no código — o único `endpoint` é o do `provider.tf` (o endereço do emulador), que **não tem nada a ver com VPC**. A route table privada está vazia de propósito (`vpc.tf:65-67`), corretamente, desde o #03.

- [ ] Declarar `aws_vpc_endpoint` com `vpc_endpoint_type = "Gateway"` e `service_name` do serviço S3 da região
- [ ] Associá-lo à **route table privada** da subnet da API
- [ ] Conferir o detalhe conceitual: um Gateway endpoint **não cria uma rota nova**. Ele se anexa à route table e passa a publicar prefix list (`pl-...`) — que é o que aparece nas rotas da subnet
- [ ] Criar SG permitindo tráfego S3 vindo da subnet privada onde roda o app

> **Lab ≠ real, obrigatório:** no LocalStack o app fala com `localhost:4566` na máquina host. As subnets `10.0.2.0/24` são objetos declarados, sem núcleo de rede real. **Não há como observar tráfego.** A prova desta Etapa é `plan` limpo com o recurso aceito pelo emulador — não é alcance verificado. Declarado ≠ funcionando.

**FIM:** `aws_vpc_endpoint` declarado e associado à route table privada; `plan` limpo; a impossibilidade de provar alcance está registrada no card.

---

## O que aprender

### Aprender A — IAM: identidade, Role vs User, least privilege

- [ ] O que é um principal e por que toda requisição à AWS precisa responder "quem sou eu"
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
- [ ] **Role vs User:** Role é assumida temporariamente por quem já está dentro da AWS; User gera access key fixa de longa duração
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
- [ ] Policy escopada num bucket vs `*`
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html

**FIM:** sei justificar por que a política atinge só o bucket; sei dizer por que uma Role é a resposta certa para o app na VPC e um access key não é.

---

### Aprender B — S3: versão, criptografia e retenção

- [ ] Versioning
  - https://docs.aws.amazon.com/AmazonS3/latest/userguide/versioning.html
- [ ] Server-side encryption
  - https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
- [ ] Lifecycle rules: por que versioning sem expiração faz o bucket crescer para sempre
  - https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html

**FIM:** sei explicar o que o versioning recupera, o que a SSE protege, e por que um `deleteObject` com versioning ligado **não** diminui o storage.

---

### Aprender C — Emulador local

- [ ] S3 e IAM emulados, endpoint local vs real
  - https://docs.localstack.cloud/user-guide/aws/s3/
  - https://docs.localstack.cloud/user-guide/aws/iam/
- [ ] `ENFORCE_IAM=1` é Pro e desligado por padrão: sem ele nada é negado
  - https://docs.localstack.cloud/aws/capabilities/security-testing/iam-policy-enforcement
- [ ] Cobertura de IAM no LocalStack: quais operações S3 já foram testadas para negação
  - https://docs.localstack.cloud/aws/capabilities/security-testing/iam-coverage

**FIM:** sei apontar endpoint local vs AWS real e o custo de cada um ($0 vs $/GB); sei dizer quais provas desta issue o emulador **não** consegue entregar.

---

## Critério de pronto

1. [ ] `validate` passa e `plan -detailed-exitcode` exit 0
2. [ ] `Put` e `Get` funcionam só no bucket alvo; **fora dele, `AccessDenied`** — com a ressalva do `ENFORCE_IAM` registrada se a negação não ocorrer
3. [ ] `aws_vpc_endpoint` declarado **e associado** à route table privada; bucket sem acesso público (`get-bucket-acl` + `get-bucket-public-access-block`)
4. [ ] Contrato das **4** variáveis de ambiente publicado; versioning + SSE + lifecycle ativos

## Dívida conhecida

Bug pré-existente, fora do escopo desta issue (proibido mexer em Java):

- `S3ReportRepository.save()` monta a chave em `report.getType() + "/" + report.getId()` (linha 66), enquanto `findById()` lê apenas `id.toString()` (linha 45). Um `save` seguido de `findById` **não encontra o objeto**.
- Tratamento: registrado aqui, a corrigir quando algum card da trilha 2 liberar alteração de código Java. Não bloqueia nenhuma Etapa desta issue — todos os critérios são validados por `awslocal`.

## Fora de escopo

- Proibido: modificar `ReportRepository`, `S3ReportRepository`, `S3Config` ou qualquer código Java; gerar conteúdo de relatório; CI/CD (issue #05); ALB (issue #03 Etapa 5); backup de banco (issue #17)
- Foco exclusivo: IAM Role + política scoped, `aws_vpc_endpoint` da subnet privada, contrato de env vars, versioning/SSE/lifecycle, validação via `awslocal`
- Não é responsabilidade desta issue: criar lane de bugs no tracker (discussão estrutural separada)

---

**Prev:** [[03-terraform-vpc]]
**Next:** [[05-github-actions]]
**Board:** [[BOARD]]
