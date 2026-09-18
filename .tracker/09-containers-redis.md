---
aliases: [issue-09, containers-redis]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-2-micro-k8s
prioridade: media
---

# Issue #09: Multi-Service Containers, Redis Streams e Webhook Gateway

## Objetivo

Evoluir de monolito conteinerizado para composição multi-serviço com mensageria e porta de entrada para webhooks.

## O que fazer

### Etapa 1 — Composição e buffer

**INÍCIO:** serviço único, chamada síncrona frágil.

- [ ] Orquestrar múltiplos serviços com isolamento de rede por perfil
- [ ] Adotar Redis Streams como buffer entre produtor e consumidor

**FIM:** produtor e consumidor desacoplados.

---

### Etapa 2 — Gateway confiável

**INÍCIO:** webhooks sem validação nem retry.

- [ ] Criar gateway com validação, idempotência e retry
- [ ] Garantir entrega sem perda sob restart de consumidor
- [ ] Observar lag de consumer group em tempo real

**FIM:** restart retoma sem duplicar efeito.

## O que aprender

### Aprender A — Streams

- [ ] Redis Streams e consumer groups
  - https://redis.io/docs/latest/develop/data-types/streams/

**FIM:** sei explicar offset e pending.

---

### Aprender B — Padrões

- [ ] Mensageria assíncrona
  - https://microservices.io/patterns/communication-with-messaging.html
- [ ] Webhooks confiáveis
  - https://docs.github.com/en/webhooks/using-webhooks/best-practices-for-using-webhooks

**FIM:** sei decidir fila vs síncrona.

## Critério de pronto

1. [ ] Resume sem perda nem duplicação
2. [ ] Idempotência provada
3. [ ] Lag observável

---

**Prev:** [[05-observability]]
**Next:** [[10-devsecops-gates]]
**Board:** [[BOARD]]
