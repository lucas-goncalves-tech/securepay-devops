---
aliases: [issue-01, linux-runtime, stage-01]
tags: [tracker, issue, todo, study-needed]
status: todo
stage: 01
rfc: RFC-001
---

# Issue #01: Linux Runtime, Processos, Redes L4 e Sinais POSIX

## Acceptance Criteria

### AC-1: Variáveis de Ambiente Desacopladas (`.env` e `.env.example`)

Criar `stages-labs/spring-cloud-platform/01-linux-runtime/.env` com as variáveis esperadas pela aplicação:

| Variável | Exemplo |
|----------|---------|
| `SPRING_DATASOURCE_URL` | `jdbc:postgresql://localhost:5432/securepay_db` |
| `SPRING_DATASOURCE_USERNAME` | `postgres` |
| `SPRING_DATASOURCE_PASSWORD` | `postgres` |
| `PORT` | `8080` |
| `JWT_SECRET` | chave de 256 bits em hexadecimal ou base64 |

- [ ] `.env` criado com todas as 5 variáveis acima
- [ ] `.env` fora do versionamento (em `.gitignore`)
- [ ] `.env.example` criado como modelo de referência (mesmas chaves, valores placeholder)

### AC-2: Script de Healthcheck Automatizado (`healthcheck.sh`)

Criar `stages-labs/spring-cloud-platform/01-linux-runtime/healthcheck.sh`:

- [ ] Permissão de execução (`chmod +x`)
- [ ] Teste L4: escuta de porta via `nc -z`, `/dev/tcp` ou `curl`
- [ ] Teste L7: consulta `/actuator/health` e verifica `status = "UP"`
- [ ] Exit code `0` quando saudável, `1` quando inacessível ou status diferente de UP

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
