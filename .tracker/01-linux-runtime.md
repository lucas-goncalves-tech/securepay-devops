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

- [x] Definir configuração por variáveis de ambiente (URL do banco, usuário, senha, porta, segredo JWT)
- [x] Implementar healthcheck em duas camadas: socket TCP (L4) + endpoint HTTP de saúde (L7)
- [x] Validar que o processo responde UP na porta configurada
- [x] Tratar SIGTERM para shutdown gracioso sem derrubar requisições em voo
- [x] Documentar como subir banco local e API na ordem correta

## O que aprender

- [x] Processos, sinais POSIX e variáveis de ambiente no Linux
  - https://man7.org/linux/man-pages/man7/signal.7.html
  - https://www.gnu.org/software/bash/manual/html_node/Environment.html
- [x] Sockets TCP e diagnóstico de portas em uso
  - https://man7.org/linux/man-pages/man8/ss.8.html
- [x] Health indicators do Spring Boot Actuator
  - https://docs.spring.io/spring-boot/reference/actuator/endpoints.html
- [x] PostgreSQL: conexão local e readiness
  - https://www.postgresql.org/docs/current/app-pg-isready.html

## Critério de pronto

- API responde 200 com corpo `status UP` no endpoint de saúde
- Healthcheck retorna exit 0 quando saudável e 1 quando falho
- SIGTERM encerra sem conexões cortadas abruptamente

---

**Next:** [[02-docker-compose]]
**Board:** [[BOARD]]
