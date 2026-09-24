---
aliases: [issue-15, caddy-reverse-proxy]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-3-vps
prioridade: alta
---

# Issue #15: Gateway L7 com TLS Automático e Headers

## Objetivo

Expor a API com HTTPS válido, roteamento por host e headers de segurança, sem gerenciar certificado na mão.

## O que fazer

### Etapa 1 — Entrada única

**INÍCIO:** API exposta direto, sem TLS.

- [ ] Subir reverse proxy como porta única
- [ ] Rotejar por domínio para upstreams internos

**FIM:** tráfego externo entra só pelo proxy.

---

### Etapa 2 — Segurança e borda

**INÍCIO:** HTTP puro, sem headers.

- [ ] Emitir TLS automático com renovação sem downtime
- [ ] Aplicar headers de segurança padrão
- [ ] Ativar compressão e logs estruturados

**FIM:** HTTPS válido; HTTP redireciona; headers presentes.

## O que aprender

### Aprender A — Proxy e TLS

- [ ] L7, ACME e certificados
  - https://caddyserver.com/docs/
  - https://letsencrypt.org/how-it-works/

**FIM:** sei explicar terminação vs passthrough.

---

### Aprender B — Headers

- [ ] Segurança de resposta
  - https://owasp.org/www-project-secure-headers/

**FIM:** sei listar headers obrigatórios.

## Critério de pronto

1. [ ] HTTPS com renovação ativa
2. [ ] Redirect HTTP→HTTPS
3. [ ] Headers verificáveis

---

**Prev:** [[14-vps-hardening]]
**Next:** [[16-compose-isolation]]
**Board:** [[BOARD]]
