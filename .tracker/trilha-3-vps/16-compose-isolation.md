---
aliases: [issue-16, compose-isolation]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-3-vps
prioridade: alta
---

# Issue #16: Compose Isolado Anti-OOM com DB Blindado

## Objetivo

Rodar produção em compose com banco inacessível da internet, limites de memória e redes internas.

## O que fazer

### Etapa 1 — Redes

**INÍCIO:** rede única, banco alcançável.

- [ ] Separar pública (proxy), interna (API) e isolada (banco)
- [ ] Blindar banco sem publicar porta externa
- [ ] Validar que só o proxy é alcançável de fora

**FIM:** banco mudo para fora da rede isolada.

---

### Etapa 2 — Recursos e resiliência

**INÍCIO:** sem limites, queda derruba host.

- [ ] Declarar limites e reservas de CPU/memória anti-OOM
- [ ] Garantir restart automático saudável

**FIM:** estouro contido; reboot da VPS volta sozinha.

## O que aprender

### Aprender A — Compose

- [ ] Redes, limites e restart
  - https://docs.docker.com/compose/how-tos/networking/
  - https://docs.docker.com/reference/compose-file/services/#deploy

**FIM:** sei desenhar as 3 redes.

---

### Aprender B — Kernel

- [ ] cgroups e OOM
  - https://docs.docker.com/engine/containers/resource_constraints/

**FIM:** sei explicar OOM-kill vs limite.

## Critério de pronto

1. [ ] Banco isolado
2. [ ] Limites contendo estouro
3. [ ] Restart pós-reboot

---

**Prev:** [[15-caddy-reverse-proxy]]
**Next:** [[17-db-backups-s3]]
**Board:** [[BOARD]]
