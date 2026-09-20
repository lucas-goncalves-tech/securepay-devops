# Fluxo ALB → API → DB no Terraform + LocalStack

Ponto mais difícil (tuas perguntas): **encadear o tráfego ALB → API → DB sem Cycle e sem buraco**.

Modelo mental que usamos o tempo todo:

```
Security Group = porteiro do prédio
ingress = quem pode ENTRAR
egress = para onde quem está DENTRO pode SAIR
```

---

## 1. Provider — quem finge ser a AWS

BLOCO estudado (`infra/provider.tf`):

```hcl
provider "aws" {
  region                      = "sa-east-1"
  access_key                  = "mock"
  secret_key                  = "mock"
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    s3    = "http://localhost:4566"
    ec2   = "http://localhost:4566"
    elbv2 = "http://localhost:4566"
  }
}
```

EXPLICAÇÃO — causa e efeito:

- Quando colocamos `access_key/secret_key = "mock"`, o provider acha credencial na hora e nem sai da máquina. Sem isso ele tenta IMDS da AWS real e quebra com `No valid credential sources found` → `plan` exit 1.
- Quando colocamos `skip_* = true`, dizemos “não tenta validar na AWS real”.
- Quando colocamos cada `endpoints`, apontamos aquele serviço para o LocalStack. Sem `elbv2`, o ALB tenta ir para a AWS real.

```
ANTES: sem mock → plan trava em auth
ADICIONAMOS: mock + skips + 3 endpoints
DEPOIS: auth passa local, pronto para criar
```

> **Nota:** foi aqui que teu `plan` saiu de exit 1 para passar da autenticação. Tu corrigiste versão para `5.0.0`, mock e `elbv2` juntos.

Comandos:

```bash
terraform init
terraform validate
terraform plan -detailed-exitcode
```

---

## 2. VPC — as 3 ruas exatas

BLOCO (`infra/vpc.tf`):

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24" # ALB, com rota internet
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24" # API
}

resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24" # banco, sem rota internet
}
```

EXPLICAÇÃO:

- Quando usamos `.1 / .2 / .3` nessa ordem, o avaliador do issue #03 reconhece os 3 tiers. Quando usamos `.10 / .20`, até roteia, mas reprova no critério “subnets exatas”.

```
10.0.1.0/24 pública (ALB mora aqui, única achável de fora)
  ↓
10.0.2.0/24 privada (API mora aqui)
  ↓
10.0.3.0/24 isolada (DB mora aqui)
```

> **Nota:** tu tinhas `.10` e `.20` e trocaste para `.2` e `.3` — era contrato, não roteamento.

---

## 3. SGs vazios + rules separadas — fim do Cycle

### 3.1 Por que deu Cycle

ANTES (inline, grudado):

```hcl
resource "aws_security_group" "api" {
  ingress { security_groups = [aws_security_group.alb.id] }
  egress { security_groups = [aws_security_group.db.id] } # ← prende api no db
}
resource "aws_security_group" "db" {
  ingress { security_groups = [aws_security_group.api.id] } # ← prende db na api
}
```

Quando fazemos isso, acontece:

```
Para criar API, preciso do ID do DB
  ↓
Para criar DB, preciso do ID da API
  ↓
travou — Cycle: alb → api → db → api
```

### 3.2 Novo estado — nasce vazio, liga depois

ADICIONAMOS:

```hcl
resource "aws_security_group" "alb" {
  name        = "securepay-alb-sg"
  description = "Regras de acesso para Load Balancer"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group" "api" {
  name        = "securepay-api-sg"
  description = "Regras de acesso para API"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group" "db" {
  name        = "securepay-db-sg"
  description = "Regras de acesso para database"
  vpc_id      = aws_vpc.main.id
}
```

DEPOIS:

```
cria alb vazio → cria api vazia → cria db vazia
  ↓
depois pendura as regras
= sem círculo, deny-all por padrão
```

> **Nota:** esse foi o erro `Cycle: aws_security_group.db / api / alb` que tu viste ao usar `security_groups` no egress inline. A fix é nunca usar bloco inline quando referencia outro SG.

### 3.3 Organização recomendada

```hcl
# 1. Esqueleto — 3 vazios em cima
# 2. # --- ALB --- rules
# 3. # --- API --- rules
# 4. # --- DB --- rules
```

> **Nota:** tu perguntaste se a rule mora colada no SG ou solta embaixo. Recomendado: SGs em cima, rules soltas embaixo agrupadas por dono (`security_group_id`). Terraform não liga para ordem, humano sim — “onde está a regra da API?” sempre na seção `# --- API ---`.

### 3.4 Velho vs novo — o `type`

Velho (`aws_security_group_rule`):

```hcl
resource "aws_security_group_rule" "alb_https_in" {
  type              = "ingress" # ou "egress" — precisa dizer a direção
  security_group_id = aws_security_group.alb.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
```

Novo (o que mantivemos):

```hcl
resource "aws_vpc_security_group_ingress_rule" "alb_https_in" { ... } # já é entrada, sem type
resource "aws_vpc_security_group_egress_rule" "alb_to_api" { ... }    # já é saída, sem type
```

- `security_group_id` = “placa pendurada em quem?”
- `cidr_ipv4` = origem/destino IP (singular, não `cidr_blocks`)
- `referenced_security_group_id` = origem/destino SG (substituto do `security_groups = [...]`)
- `ip_protocol` = antigo `protocol`, renomeado no novo

> **Nota:** teu autocomplete pediu `type = ""` porque no recurso velho ele não sabe se é entrada ou saída. No novo o nome já diz, sem `type`.

---

## 4. Fluxo completo ALB → API → DB

### 4.1 ALB recebe — 80 e 443

```hcl
resource "aws_vpc_security_group_ingress_rule" "alb_http_in" {
  description       = "Internet -> ALB:80"
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_in" {
  description       = "Internet -> ALB:443"
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443 # tu corrigiste de 433 para 443
  ip_protocol       = "tcp"
}
```

Por que 80 se o frontend envia HTTPS?

```
Browser --HTTPS 443--> ALB --HTTP 8080--> API
         criptografado      aberto mas dentro da VPC privada
```

- 443 precisa de certificado no listener. 80 não. O issue pede o caminho mínimo 80 → forward, sem ACM. Mantemos SG 80+443, só listener 80 por enquanto.

> **Nota:** `0.0.0.0/0` aqui é a única exceção permitida — ALB público precisa ser achável. Erro seria usar `0.0.0.0/0` na API ou DB.

### 4.2 ALB → API (par espelhado)

Saída do ALB:

```hcl
resource "aws_vpc_security_group_egress_rule" "alb_to_api" {
  description                  = "ALB -> API:8080"
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.api.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}
```

Entrada da API:

```hcl
resource "aws_vpc_security_group_ingress_rule" "api_from_alb" {
  description                  = "ALB -> API 8080"
  security_group_id            = aws_security_group.api.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}
```

Quando colocamos as duas, a AWS checa os dois porteiros — saída de quem manda + entrada de quem recebe. Falta uma, barra.

```
ANTES no teu arquivo velho: cidr 10.0.0.0/16 = 65 mil IPs
DEPOIS: referenced api.id = só a API
```

### 4.3 API → DB (tu fizeste sozinho)

Tua regra (certa):

```hcl
resource "aws_vpc_security_group_egress_rule" "api_to_db" {
  description                  = "API -> DB:5432"
  security_group_id            = aws_security_group.api.id
  referenced_security_group_id = aws_security_group.db.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}
```

Espelho no DB:

```hcl
resource "aws_vpc_security_group_ingress_rule" "db_from_api" {
  description                  = "DB:5432 <- API"
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.api.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}
```

DB sem nenhuma saída — certo, banco não inicia conversa.

Egress aberto que removemos da API (`0.0.0.0/0` + `-1`): se a API fosse comprometida, ela discaria qualquer IP/porta (exfiltração, malware). Agora só 5432 para o DB.

### 4.4 Redis — por que esperar

```
REDIS_ENABLED=false → NoOp, nem tenta 6379 → regra inútil agora
REDIS_ENABLED=true → tenta 6379 → barra no egress só-5432 → timeout
```

Regra: só abre o que usa hoje. Quando ligar o Redis, repete o par do 5432 na 6379. O erro `timeout` será o professor.

---

## 5. ALB lógico — TG + Listener + health check

ALB:

```hcl
resource "aws_lb" "main" {
  name               = "securepay-alb"
  load_balancer_type = "application" # entende HTTP + path
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public.id]
}
```

Target Group:

```hcl
resource "aws_lb_target_group" "api" {
  name     = "securepay-api-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path     = "/actuator/health" # 200 sem auth, não `/` com JWT
    port     = "8080"
    protocol = "HTTP"
    matcher  = "200"
  }
}
```

Listener:

```hcl
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}
```

Fluxo final:

```
internet :80/:443 → ALB
  ↓ listener 80 forward?
TG checa GET :8080/actuator/health = 200?
  ↓ healthy?
API :8080 ✅
```

443 com listener exigiria `certificate_arn` (ACM) — por isso só SG 443 agora, listener 443 depois em prod com redirect 80→443.

---

## 6. Prova e limite atual

```bash
terraform validate # exit 0 — código inteiro válido, incluindo ALB
terraform plan -target=aws_vpc.main \
  -target=aws_subnet.public -target=aws_subnet.private -target=aws_subnet.db \
  -target=aws_security_group.alb -target=aws_security_group.api -target=aws_security_group.db \
  -target=aws_s3_bucket.financial_reports \
  -target=aws_s3_bucket_public_access_block.financial_reports_privacy \
  -detailed-exitcode # exit 0, No changes — base aplicada sem drift
```

> **Nota:** `apply` completo trava em `elbv2.CreateLoadBalancer => 501 not included within your LocalStack license`. Logs mostram `ec2/s3 => 200`, só `elbv2 => 501`. Sem `AUTH_TOKEN` a imagem atual nem sobe. Caminho possível agora: base aplicada + ALB code-complete validado, apply do ALB pendente de tier Pro. Sem custo real, conforme `AGENTS.md`.

---

## Resumo

- Provider mock + 3 endpoints destrava auth local.
- Subnets exatas `.1/.2/.3` fecham critério do issue.
- SG vazio + `aws_vpc_security_group_*_rule` separado elimina Cycle.
- Organização: SGs em cima, rules embaixo por `# --- ALB/API/DB ---`.
- Par espelhado sempre: egress de quem manda + ingress de quem recebe.
- `referenced_*` > CIDR largo dentro da VPC; `0.0.0.0/0` só no ALB.
- Listener 80 sem cert fecha o issue; 443 com ACM é evolução.
- Health em `/actuator/health`, não `/`.
- Redis e listener 443: abrir quando usar, não antes.
