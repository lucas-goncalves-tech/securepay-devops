# SecurePay DevOps

AI-assisted payment API (ledger-service) built with Spring Boot 21, deployed through a progressive DevOps pipeline. The agent's role is to assist with infrastructure, CI/CD, observability, and operational tasks — not to modify business logic unless explicitly asked.

## Filetree

```
securepay-devops/
├── AGENTS.md
├── healthcheck.sh
├── backend/                    # Spring Boot payment API
│   ├── Dockerfile
│   ├── docker-compose.yaml
│   ├── pom.xml
│   └── src/
│       └── main/java/com/securepay/ledger/
│           ├── domain/         # Entities + repositories (JPA)
│           ├── event/          # PaymentEventPublisher (Redis/NoOp)
│           ├── report/         # ReportRepository (S3/NoOp) — infra-agnostic
│           ├── payment/        # PaymentService, WalletService
│           ├── security/       # JWT auth, SecurityConfig
│           └── infrastructure/ # GlobalExceptionHandler, OpenApiConfig
├── infra/                      # Terraform IaC
│   ├── provider.tf             # AWS provider + LocalStack endpoints
│   └── vpc.tf                  # VPC multi-tier + subnets
├── stage/                      # DevOps learning stages
│   ├── 01-linux-runtime/
│   ├── 02-docker-compose/
│   ├── 03-terraform-vpc/
│   ├── 04-github-actions/
│   └── 05-observability/
├── .tracker/                   # Obsidian-compatible issue tracker
│   ├── BOARD.md
│   ├── 01-linux-runtime.md
│   ├── 02-docker-compose.md
│   ├── 03-terraform-vpc.md     # + ALB (Etapa 5)
│   ├── 04-github-actions.md
│   ├── 05-observability.md
│   └── 18-s3-reports-infra.md  # S3 bucket + IAM for reports
└── .agents/skills/             # Matt Pocock engineering skills
```

## DevOps Pipeline

| Stage | Focus | Status |
|-------|-------|--------|
| 01 | Linux runtime, env vars, healthcheck, POSIX signals | Done |
| 02 | Multi-stage Dockerfile, Docker Compose, non-root user | Done |
| 03 | Terraform HCL, VPC multi-tier, ALB, LocalStack | To Do |
| 18 | S3 Reports Infra — bucket, IAM, endpoint | To Do |
| 04 | GitHub Actions CI/CD, Trivy scanning, IaC gates | To Do |
| 05 | Prometheus, Grafana dashboards, k6 load testing | To Do |

## Backend Architecture

### Infrastructure Ports (Interfaces)

The app uses ports to remain infrastructure-agnostic. Each port has a NoOp (default) and a real implementation activated via `@ConditionalOnProperty`.

| Port | Interface | NoOp | Real | Activated by |
|------|-----------|------|------|--------------|
| Events | `PaymentEventPublisher` | `NoOpPaymentEventPublisher` | `RedisPaymentEventPublisher` | `REDIS_ENABLED=true` |
| Reports | `ReportRepository` | `NoOpReportRepository` | `S3ReportRepository` | `S3_ENABLED=true` |

### Environment Variables (Infrastructure Contract)

When infra is ready, the app expects:

| Variable | Default | Used by |
|----------|---------|---------|
| `SPRING_DATASOURCE_URL` | `jdbc:postgresql://localhost:5432/securepay_db` | PostgreSQL |
| `SPRING_DATA_REDIS_HOST` | `localhost` | Redis |
| `REDIS_ENABLED` | `false` | Event publisher |
| `S3_ENABLED` | `false` | Report repository |
| `S3_BUCKET_NAME` | `securepay-financial-reports` | S3 reports |
| `AWS_REGION` | `sa-east-1` | S3 region |
| `S3_ENDPOINT_URL` | (empty) | LocalStack only |
| `JWT_SECRET` | (built-in) | JWT signing |

### Infra → App Wiring

When infra is created, set these to activate real implementations:
- **Redis**: `REDIS_ENABLED=true`, `SPRING_DATA_REDIS_HOST=<redis-host>`
- **S3**: `S3_ENABLED=true`, `S3_BUCKET_NAME=<bucket>`, `AWS_REGION=<region>`, `S3_ENDPOINT_URL=<endpoint>` (LocalStack only)

## Startup

Invoke `using-superpowers` at session start to load the skill framework. The user triggers `/ask-matt` when they need a skill router.

## Conventions

- All infra targets LocalStack (`localhost:4566`) in `sa-east-1` — no real AWS costs
- Backend: Java 21, Maven, Spring Boot with Actuator endpoints
- Healthcheck: L4 port check + L7 `/actuator/health` (status UP)
- Security: non-root containers, no ports exposed to 0.0.0.0/0, JWT auth
- Infra isolation: backend uses interfaces (`ReportRepository`, `PaymentEventPublisher`) — never depends directly on S3, Redis, or other infra
- Infra activation: `@ConditionalOnProperty` switches NoOp ↔ real implementation
