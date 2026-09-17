---
aliases: [issue-02, docker-compose, stage-02]
tags: [tracker, issue, done]
status: done
stage: 02
rfc: RFC-002
---

# Issue #02: Conteinerização Profissional e Docker Compose

## Acceptance Criteria

### AC-1: Dockerfile Multi-Stage (`backend/Dockerfile`)

- [ ] **Estágio de Build (`builder`):** Imagem base com JDK 21 para compilar e gerar o `.jar`
- [ ] **Estágio de Runtime (`runtime`):** Imagem minimalista com JRE (ex: `eclipse-temurin:21-jre-alpine`), copiando apenas o `.jar` do builder
- [ ] **Execução Não-Root:** Grupo e usuário dedicados (`addgroup -S spring && adduser -S spring -G spring`) + diretiva `USER spring`
- [ ] **Tamanho Limite:** Imagem final < 220 MB
- [ ] **`.dockerignore`:** Exclui `target/`, `.git/`, `.env`

### AC-2: Orquestração Declarativa (`docker-compose.yaml`)

Serviço `postgres`:
- [ ] Imagem `postgres:16-alpine`
- [ ] Volume nomeado persistindo `/var/lib/postgresql/data`
- [ ] `healthcheck` com `pg_isready -U postgres`

Serviço `ledger-service`:
- [ ] Contexto de build apontando para o backend
- [ ] Variável `SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/securepay_db`
- [ ] `depends_on` com `condition: service_healthy`

### AC-3: Validação de Execução no Terminal

- [ ] `docker compose up -d` — ambos os serviços sobem
- [ ] `docker compose ps` — ambos em estado `healthy`

### AC-4: Encerramento Gracioso com Sinal SIGTERM

- [ ] `docker compose stop ledger-service` — Spring Boot intercepta SIGTERM
- [ ] Logs mostram HikariCP fechando conexões ordenadamente antes do exit

## Scope

- Multi-stage Dockerfile, Alpine image reduction, non-root user (`USER spring`), `docker-compose.yml` with `condition: service_healthy`, volume persistence
- **Out of scope:** Terraform, Kubernetes/Helm, LocalStack AWS, AWS ECS/EKS, remote CI/CD

## Study Completed

- [x] Docker Multi-stage Builds Best Practices
- [x] Compose Specification: depends_on
- [x] Spring Boot in Docker (Official Guide)

## References

- [Docker Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Compose Specification: depends_on](https://docs.docker.com/compose/compose-file/05-services/#depends_on)
- [Spring Boot in Docker](https://spring.io/guides/gs/spring-boot-docker/)

## Validation

```bash
python3 stages-labs/spring-cloud-platform/02-docker-compose/verify.py
```

---

**Prev:** [[01-linux-runtime]]
**Next:** [[03-terraform-vpc]]
**Board:** [[BOARD]]
