---
aliases: [issue-04, s3-reports-infra]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-1-core
prioridade: alta
---

# Issue #04: Infraestrutura S3 para Relatórios Financeiros

## Objetivo

Dar ao app storage persistente para relatórios financeiros (PDF/CSV): IAM com least privilege, endpoint S3 alcançável da subnet privada e contrato de variáveis de ambiente — tornando o `S3ReportRepository` funcional sem modificar código do app.

## O que fazer

### Etapa 1 — IAM com least privilege

**INÍCIO:** o bucket existe (#03), mas ninguém tem credencial para usá-lo.

- [ ] Criar IAM user `securepay-reports-user`
- [ ] Declarar política `Effect: Allow` apenas para `s3:PutObject`, `s3:GetObject` e `s3:DeleteObject` no bucket `securepay-financial-reports` — nunca `*`
- [ ] Expôr credenciais somente via variáveis de ambiente, nunca em código

**FIM:** credenciais do user funcionam dentro do bucket e são negadas fora dele.

---

### Etapa 2 — Acesso a partir da rede privada

**INÍCIO:** endpoint S3 declarado no provider (#03), mas alcance da subnet privada não verificado.

- [ ] Verificar se o endpoint S3 é alcançável da subnet privada via route table
- [ ] Criar SG permitindo tráfego S3 vindo da subnet privada onde roda o app

**FIM:** app na subnet privada alcança o S3 sem nenhuma exposição pública.

---

### Etapa 3 — Bucket e contrato com o app

**INÍCIO:** bucket básico criado no #03, sem proteções de conteúdo nem contrato publicado.

- [ ] Reusar o bucket `securepay-financial-reports` (movê-lo para `infra/s3.tf` se a organização exigir)
- [ ] Habilitar versioning e server-side encryption (AES256)
- [ ] Publicar o contrato de variáveis que o app espera:
  - `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` — credenciais do IAM user
  - `AWS_REGION` — `sa-east-1`
  - `S3_BUCKET_NAME` — `securepay-financial-reports`
  - `S3_ENDPOINT_URL` — `http://localhost:4566` (somente LocalStack; AWS real usa o endpoint regional)

**FIM:** app configurável 100% por env vars, sem hardcode; bucket versionado e criptografado.

---

### Etapa 4 — Validação determinística

**INÍCIO:** recursos declarados, nada validado.

- [ ] `terraform init && terraform validate` passam
- [ ] `terraform plan -detailed-exitcode` retorna exit 0 (sem drift)
- [ ] `awslocal s3 ls` acessa o bucket
- [ ] Put/get/delete com as credenciais do IAM user funcionam
- [ ] `awslocal s3api get-bucket-acl` confirma zero acesso público

**FIM:** tudo validado por comando determinístico, nada manual.

## O que aprender

### Aprender A — IAM e least privilege

- [ ] Users, policies e escopo mínimo
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
- [ ] Policy escopada num bucket vs `*`
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html

**FIM:** sei justificar por que a política atinge só o bucket; sei dizer quando AWS real usa IAM Role em vez de access key.

---

### Aprender B — S3: versão e criptografia

- [ ] Versioning
  - https://docs.aws.amazon.com/AmazonS3/latest/userguide/versioning.html
- [ ] Server-side encryption
  - https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html

**FIM:** sei explicar o que o versioning recupera e o que a SSE protege.

---

### Aprender C — Emulador local

- [ ] S3 e IAM emulados, endpoint local vs real
  - https://docs.localstack.cloud/user-guide/aws/s3/
  - https://docs.localstack.cloud/user-guide/aws/iam/

**FIM:** sei apontar endpoint local vs AWS real e o custo de cada um ($0 vs $/GB).

## Critério de pronto

1. [ ] `validate` passa e `plan -detailed-exitcode` exit 0
2. [ ] Put/get/delete funcionam só no bucket alvo; fora dele, negado
3. [ ] Bucket alcançável da subnet privada e sem acesso público (`get-bucket-acl`)
4. [ ] Contrato das 5 variáveis de ambiente publicado; versioning + SSE ativos

## Fora de escopo

- Proibido: modificar `ReportRepository`, `S3ReportRepository` ou qualquer código Java; gerar conteúdo de relatório; CI/CD (issue #05); ALB (issue #03 Etapa 5); backup de banco (issue #17)
- Foco exclusivo: IAM user + política scoped, SG/endpoint da subnet privada, contrato de env vars, versioning/SSE, validação via `awslocal`

---

**Prev:** [[03-terraform-vpc]]
**Next:** [[05-github-actions]]
**Board:** [[BOARD]]
