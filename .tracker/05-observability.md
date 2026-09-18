---
aliases: [issue-05, observability, stage-05]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-1-core
prioridade: alta
---

# Issue #05: Observabilidade, Golden Signals e Teste de Carga

## Objetivo

Provar em produção local que a API sustenta concorrência real sem starvation de banco, com latência e pool observáveis.

## O que fazer

### Etapa 1 — Coleta

**INÍCIO:** app no escuro, sem métricas.

- [ ] Orquestrar coletor em `9090` e dashboard em `3000` na mesma rede da API
- [ ] Expor `/actuator/prometheus`; job `ledger-service` com scraping `5s`

**FIM:** métricas fluindo em tempo real.

---

### Etapa 2 — Dashboard (4 painéis)

**INÍCIO:** dados existem, mas ninguém vê gargalo.

- [ ] Painel 1 RPS por status (`http_server_requests_seconds_count`)
- [ ] Painel 2 p95/p99 de `/api/v1/payments/transfer`
- [ ] Painel 3 HikariCP (`hikaricp_connections_active`, `_idle`, `_pending`)
- [ ] Painel 4 heap JVM (`jvm_memory_used_bytes{area="heap"}`)

**FIM:** 4 painéis no ar com as métricas exatas.

---

### Etapa 3 — Carga com SLO

**INÍCIO:** dashboard bonito, resiliência não provada.

- [ ] Carga k6 50–100 VUs contra `/api/v1/payments/transfer` com `X-Idempotency-Key`
- [ ] Validar `http_req_failed < 0.01` e `http_req_duration{p(95)<500}`; observar `connection-timeout: 20s`

**FIM:** carga passa sem starvation; média de 120ms não esconde cauda > 5s.

## O que aprender

### Aprender A — Métricas

- [ ] Actuator + Micrometer
  - https://docs.spring.io/spring-boot/reference/actuator/metrics.html
  - https://micrometer.io/docs
- [ ] Scraping Prometheus
  - https://prometheus.io/docs/prometheus/latest/configuration/configuration/

**FIM:** sei explicar o que cada métrica mede.

---

### Aprender B — Visualização e carga

- [ ] Grafana e PromQL
  - https://grafana.com/docs/grafana/latest/dashboards/
  - https://prometheus.io/docs/prometheus/latest/querying/basics/
- [ ] k6 e thresholds
  - https://grafana.com/docs/k6/
- [ ] HikariCP
  - https://github.com/brettwooldridge/HikariCP

**FIM:** sei apontar gargalo (GC, threads, contenção, pool) no gráfico.

## Critério de pronto

1. [ ] 4 painéis com métricas exatas
2. [ ] k6 dentro dos thresholds, sem starvation
3. [ ] Diagnóstico de gargalo demonstrável

## Fora de escopo

- Proibido: Jaeger com OpenTelemetry Collector, Chaos Engineering complexo, clusters ELK
- Foco exclusivo: scraping `/actuator/prometheus`, `prometheus.yml`, Grafana (RPS, p95/p99, HikariCP) e k6 sem starvation

---

**Prev:** [[04-github-actions]]
**Next:** [[09-containers-redis]]
**Board:** [[BOARD]]
