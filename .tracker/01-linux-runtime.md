---
aliases: [issue-01, linux-runtime, stage-01]
tags: [tracker, issue, done]
status: done
trilha: trilha-1-core
prioridade: alta
---

# Issue #01: Linux Runtime, Env, Healthcheck e Sinais POSIX

## Objetivo

Garantir que o backend sobe de forma previsível no Linux local, com configuração por ambiente e desligamento gracioso.

## O que fazer

> Faça na ordem. Cada Etapa tem INÍCIO e FIM claros — só avance quando o FIM estiver cumprido.

### Etapa 1 — Configuração por ambiente

**INÍCIO:** nenhuma variável documentada.

- [x] Definir URL do banco, usuário, senha, porta e segredo JWT via ambiente
- [x] Documentar como subir banco local e API na ordem correta

**FIM:** variáveis esperadas conhecidas — URL `jdbc:postgresql://localhost:5432/securepay_db`, usuário `postgres`, senha `postgres`, porta `8080`, JWT 256 bits em hex ou base64.

---

### Etapa 2 — Healthcheck em duas camadas

**INÍCIO:** processo sobe mas ninguém prova que está saudável.

- [x] Implementar teste L4 via socket TCP (`/dev/tcp` ou `nc -z`)
- [x] Implementar teste L7 via `/actuator/health` exigindo `"UP"`
- [x] Validar que o processo responde UP na porta configurada, conferida via `ss -tulpn`

**FIM:** healthcheck retorna exit 0 saudável / 1 falho; API responde 200 com `status UP`.

---

### Etapa 3 — Shutdown gracioso

**INÍCIO:** healthcheck passa, mas kill pode corromper.

- [x] Tratar SIGTERM para fechar conexões sem derrubar requisições em voo

**FIM:** SIGTERM encerra sem conexões cortadas abruptamente.

## O que aprender

### Aprender A — Processos e ambiente

- [x] Sinais POSIX e variáveis de ambiente
  - https://man7.org/linux/man-pages/man7/signal.7.html
  - https://www.gnu.org/software/bash/manual/html_node/Environment.html

**FIM:** sei explicar SIGTERM vs kill forçado.

---

### Aprender B — Rede e saúde

- [x] Sockets TCP e portas em uso
  - https://man7.org/linux/man-pages/man8/ss.8.html
- [x] Health indicators do Spring Boot Actuator
  - https://docs.spring.io/spring-boot/reference/actuator/endpoints.html
- [x] PostgreSQL local e readiness
  - https://www.postgresql.org/docs/current/app-pg-isready.html

**FIM:** sei diagnosticar porta ocupada vs app fora do ar.

## Critério de pronto

1. [x] API 200 com `status UP`
2. [x] Healthcheck exit 0/1 correto
3. [x] SIGTERM limpo

## Fora de escopo

- Proibido: Docker, Docker Compose, Terraform, Kubernetes, LocalStack, CI/CD
- Foco exclusivo: processos Linux, permissões de arquivo, variáveis de ambiente, portas locais, PostgreSQL no host e healthcheck em bash

---

**Prev:** [[00-visao-geral]]
**Next:** [[02-docker-compose]]
**Board:** [[BOARD]]
