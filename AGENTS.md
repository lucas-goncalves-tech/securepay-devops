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
├── infra/                      # Terraform IaC (planned)
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
│   ├── 03-terraform-vpc.md
│   ├── 04-github-actions.md
│   └── 05-observability.md
└── .agents/skills/             # Matt Pocock engineering skills
```

## DevOps Pipeline

| Stage | Focus | Status |
|-------|-------|--------|
| 01 | Linux runtime, env vars, healthcheck, POSIX signals | To Do |
| 02 | Multi-stage Dockerfile, Docker Compose, non-root user | Done |
| 03 | Terraform HCL, VPC multi-tier, LocalStack, S3 | To Do |
| 04 | GitHub Actions CI/CD, Trivy scanning, IaC gates | To Do |
| 05 | Prometheus, Grafana dashboards, k6 load testing | To Do |

## Startup

Invoke `using-superpowers` at session start to load the skill framework. The user triggers `/ask-matt` when they need a skill router.

## Conventions

- All infra targets LocalStack (`localhost:4566`) in `sa-east-1` — no real AWS costs
- Backend: Java 21, Maven, Spring Boot with Actuator endpoints
- Healthcheck: L4 port check + L7 `/actuator/health` (status UP)
- Security: non-root containers, no ports exposed to 0.0.0.0/0, JWT auth
