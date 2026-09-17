---
aliases: [issue-02, docker-compose, stage-02]
tags: [tracker, issue, done]
status: done
stage: 02
rfc: RFC-002
---

# Issue #02: Conteinerização Profissional e Docker Compose

## Acceptance Criteria

- [x] Dockerfile Multi-Stage (`backend/Dockerfile`)
- [x] Orquestração Declarativa (`docker-compose.yaml`)
- [x] Validação de Execução no Terminal
- [x] Encerramento Gracioso com Sinal SIGTERM

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
