---
aliases: [issue-01, linux-runtime, stage-01]
tags: [tracker, issue, todo, study-needed]
status: todo
stage: 01
rfc: RFC-001
---

# Issue #01: Linux Runtime, Processos, Redes L4 e Sinais POSIX

## Acceptance Criteria

- [ ] Variáveis de Ambiente Desacopladas (`.env` e `.env.example`)
- [ ] Script de Healthcheck Automatizado (`healthcheck.sh`)

## Scope

- Linux processes, file permissions, `.env` variables, local ports (`ss -tulpn`), PostgreSQL on host, bash healthcheck script
- **Out of scope:** Docker, Docker Compose, Terraform, Kubernetes, LocalStack, CI/CD

## Study Needed

- [ ] Spring Boot Externalized Configuration
- [ ] Spring Boot Graceful Shutdown
- [ ] Linux Signals and Traps (man 7 signal)

## References

- [Spring Boot Externalized Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config)
- [Spring Boot Graceful Shutdown](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.graceful-shutdown)
- [Linux Signals and Traps](https://man7.org/linux/man-pages/man7/signal.7.html)

## Validation

```bash
python3 stages-labs/spring-cloud-platform/01-linux-runtime/verify.py
```

---

**Next:** [[02-docker-compose]]
**Board:** [[BOARD]]
