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

- [x] Criar build em múltiplos estágios separando compilação e runtime
- [x] Reduzir imagem final para patamar enxuto com base mínima
- [x] Rodar o processo como usuário sem privilégios (non-root)
- [x] Configurar flags de memória ciente de container para a JVM
- [x] Orquestrar API + banco com volume persistente e healthcheck do banco
- [x] Garantir que a API só sobe quando o banco está saudável

## O que aprender

- [x] Multi-stage builds e boas práticas de imagem
  - https://docs.docker.com/build/building/multi-stage/
  - https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
- [x] Compose: depends_on com condição de saúde e volumes
  - https://docs.docker.com/compose/how-tos/startup-order/
  - https://docs.docker.com/reference/compose-file/services/#healthcheck
- [x] JVM em containers (memória e CPU)
  - https://docs.oracle.com/en/java/javase/21/gctuning/
- [x] PostgreSQL em container e persistência
  - https://hub.docker.com/_/postgres

## Critério de pronto

- Imagem final abaixo do teto definido e sem rodar como root
- Banco persiste dados após restart do compose
- API aguarda banco saudável antes de aceitar tráfego

---

**Prev:** [[01-linux-runtime]]
**Next:** [[03-terraform-vpc]]
**Board:** [[BOARD]]
