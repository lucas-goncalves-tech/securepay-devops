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

- [ ] Orquestrar stack: coletor em `9090` e dashboard em `3000` na mesma rede da API
- [ ] Expor métricas via `/actuator/prometheus` do Actuator
- [ ] Configurar job `ledger-service` com scraping `5s`
- [ ] Criar dashboard com 4 painéis: RPS por status (`http_server_requests_seconds_count`), p95/p99 de `/api/v1/payments/transfer`, HikariCP ativa/ociosa/pendente (`hikaricp_connections_active`, `_idle`, `_pending`), heap JVM (`jvm_memory_used_bytes{area="heap"}`)
- [ ] Criar carga k6 com 50–100 VUs contra `/api/v1/payments/transfer` com header `X-Idempotency-Key`
- [ ] Validar thresholds: `http_req_failed < 0.01` e `http_req_duration{p(95)<500}`; investigar starvation com `connection-timeout: 20s` em mente

## O que aprender

- [ ] Actuator + Micrometer e métricas de produção
  - https://docs.spring.io/spring-boot/reference/actuator/metrics.html
  - https://micrometer.io/docs
- [ ] Configuração de scraping do Prometheus
  - https://prometheus.io/docs/prometheus/latest/configuration/configuration/
- [ ] Dashboards Grafana (PromQL para RPS, histogramas, p95/p99)
  - https://grafana.com/docs/grafana/latest/dashboards/
  - https://prometheus.io/docs/prometheus/latest/querying/basics/
- [ ] Teste de carga e thresholds
  - https://grafana.com/docs/k6/
- [ ] Pool HikariCP e gargalos de conexão
  - https://github.com/brettwooldridge/HikariCP

## Critério de pronto

- Dashboard mostra RPS, p95/p99, pool e heap em tempo real com as métricas exatas acima
- Carga 50–100 VUs passa com `http_req_failed < 0.01` e p95 < 500ms, sem starvation do banco
- Média ilusória (ex: 120ms) não esconde cauda p95/p99 (risco > 5s); sei apontar gargalo (GC, threads HTTP, contenção, pool)
- Sei apontar no gráfico onde mora o gargalo (I/O, pool ou heap)

## Fora de escopo

- Proibido: Jaeger com OpenTelemetry Collector, Chaos Engineering complexo, clusters ELK
- Foco exclusivo: scraping `/actuator/prometheus`, `prometheus.yml`, Grafana (RPS, p95/p99, HikariCP) e k6 sem starvation

---

**Prev:** [[04-github-actions]]
**Next:** [[09-containers-redis]]
**Board:** [[BOARD]]
