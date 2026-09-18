---
aliases: [issue-15, compose-isolation]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-3-vps
prioridade: alta
---

# Issue #15: Compose Isolado Anti-OOM com DB Blindado

## Objetivo

Rodar produção em compose com banco inacessível da internet, limites de memória e redes internas.

## O que fazer

- [ ] Separar redes: pública (proxy), interna (API) e isolada (banco)
- [ ] Declarar limites e reservas de memória e CPU para evitar OOM do host
- [ ] Blindar banco sem publicação de porta externa
- [ ] Garantir restart automático com política saudável
- [ ] Validar que só o proxy é alcançável de fora

## O que aprender

- [ ] Redes, limites e restart policies no Compose
  - https://docs.docker.com/compose/how-tos/networking/
  - https://docs.docker.com/reference/compose-file/services/#deploy
- [ ] cgroups, OOM e dimensionamento
  - https://docs.docker.com/engine/containers/resource_constraints/

## Critério de pronto

- Banco não responde de fora da rede isolada
- Container estourando limite é contido sem derrubar o host
- Após reboot da VPS a plataforma volta sozinha

---

**Prev:** [[14-caddy-reverse-proxy]]
**Next:** [[16-db-backups-s3]]
**Board:** [[BOARD]]
