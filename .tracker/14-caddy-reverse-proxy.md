---
aliases: [issue-14, caddy-reverse-proxy]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-3-vps
prioridade: alta
---

# Issue #14: Gateway L7 com TLS Automático e Headers

## Objetivo

Expor a API com HTTPS válido, roteamento por host e headers de segurança, sem gerenciar certificado na mão.

## O que fazer

- [ ] Subir reverse proxy como porta de entrada única
- [ ] Emitir TLS automático com renovação sem downtime
- [ ] Rotejar por domínio para upstreams internos
- [ ] Aplicar headers de segurança padrão
- [ ] Ativar compressão e logs de acesso estruturados

## O que aprender

- [ ] Reverse proxy L7, TLS e ACME
  - https://caddyserver.com/docs/
  - https://letsencrypt.org/how-it-works/
- [ ] Headers de segurança
  - https://owasp.org/www-project-secure-headers/

## Critério de pronto

- HTTPS válido com renovação automática ativa
- HTTP redireciona para HTTPS
- Headers de segurança presentes em resposta pública
- Sei explicar terminação TLS vs passthrough

---

**Prev:** [[13-vps-hardening]]
**Next:** [[15-compose-isolation]]
**Board:** [[BOARD]]
