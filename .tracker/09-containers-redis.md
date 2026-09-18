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

- [ ] Orquestrar múltiplos serviços com isolamento de rede por perfil
- [ ] Adotar Redis Streams como buffer entre produtor e consumidor
- [ ] Criar gateway de webhooks com validação, idempotência e retry
- [ ] Garantir entrega sem perda sob restart de consumidor
- [ ] Observar lag de consumer group em tempo real

## O que aprender

- [ ] Redis Streams e consumer groups
  - https://redis.io/docs/latest/develop/data-types/streams/
- [ ] Padrões de mensageria (at-least-once, idempotência)
  - https://microservices.io/patterns/communication-with-messaging.html
- [ ] Design de webhooks confiáveis
  - https://docs.github.com/en/webhooks/using-webhooks/best-practices-for-using-webhooks

## Critério de pronto

- Consumidor reiniciado retoma de onde parou sem duplicar efeito
- Webhook com mesma chave de idempotência não gera efeito colateral duplo
- Sei explicar quando usar fila vs chamada síncrona

---

**Prev:** [[05-observability]]
**Next:** [[10-devsecops-gates]]
**Board:** [[BOARD]]
