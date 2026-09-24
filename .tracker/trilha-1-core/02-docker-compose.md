---
aliases: [issue-02, docker-compose, stage-02]
tags: [tracker, issue, done]
status: done
trilha: trilha-1-core
prioridade: alta
---

# Issue #02: Conteinerização Profissional e Docker Compose

## Objetivo

Empacotar o backend em imagem enxuta, segura e reproduzível, com banco orquestrado e dependência saudável.

## O que fazer

### Etapa 1 — Imagem enxuta e segura

**INÍCIO:** build inclui ferramentas e roda como root.

- [x] Criar build em múltiplos estágios separando compilação (JDK 21) e runtime (JRE mínimo, base Alpine)
- [x] Reduzir imagem final para menos de 220 MB
- [x] Rodar como usuário sem privilégios (ex: `spring`), nunca root
- [x] Configurar flags de memória ciente de container para a JVM
- [x] Enxugar contexto excluindo `target/`, `.git/`, `.env`

**FIM:** imagem < 220 MB, non-root, só com o artefato final.

---

### Etapa 2 — Orquestração com dependência saudável

**INÍCIO:** imagem pronta, mas API pode subir antes do banco.

- [x] Orquestrar API + banco (`postgres:16-alpine`) com volume persistente em `/var/lib/postgresql/data`
- [x] Healthcheck do banco via `pg_isready`; URL interna `jdbc:postgresql://postgres:5432/securepay_db`
- [x] Garantir que a API só sobe quando o banco está saudável (dependência condicional)
- [x] Confirmar parada com SIGTERM e fechamento ordenado do pool HikariCP

**FIM:** banco persiste após restart; API aguarda saúde antes de aceitar tráfego.

## O que aprender

### Aprender A — Imagens

- [x] Multi-stage builds e boas práticas
  - https://docs.docker.com/build/building/multi-stage/
  - https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
- [x] JVM em containers
  - https://docs.oracle.com/en/java/javase/21/gctuning/

**FIM:** sei dizer o que engorda imagem e como provar o tamanho.

---

### Aprender B — Compose

- [x] Ordem de subida e healthcheck
  - https://docs.docker.com/compose/how-tos/startup-order/
  - https://docs.docker.com/reference/compose-file/services/#healthcheck
- [x] PostgreSQL em container e persistência
  - https://hub.docker.com/_/postgres

**FIM:** sei explicar por que dependência cega quebra o pool.

## Critério de pronto

1. [x] Imagem < 220 MB, non-root
2. [x] Dados sobrevivem ao restart
3. [x] API aguarda banco saudável; SIGTERM limpo

## Fora de escopo

- Proibido: Terraform, Kubernetes/Helm, LocalStack, ECS/EKS, CI/CD remoto
- Foco exclusivo: multi-stage enxuto Alpine, usuário sem privilégios, ordenação por saúde e persistência de volume

---

**Prev:** [[01-linux-runtime]]
**Next:** [[03-terraform-vpc]]
**Board:** [[BOARD]]
