---
aliases: [issue-05, observability, stage-05]
tags: [tracker, issue, todo, study-needed]
status: todo
stage: 05
rfc: RFC-005
---

# Issue #05: Observabilidade, Métricas de Produção e Confiabilidade (SRE)

## Acceptance Criteria

### AC-1: Orquestração de Observabilidade (`docker-compose.observability.yml`)

- [ ] Serviço **Prometheus** (`prom/prometheus:latest`) porta `9090:9090`, monta `prometheus.yml`
- [ ] Serviço **Grafana** (`grafana/grafana:latest`) porta `3000:3000`
- [ ] Rede compartilhada entre Prometheus e `ledger-service`
- [ ] Aceito como fallback: pasta do estágio ou `infra/ledger-service/observability/`

### AC-2: Configuração do Prometheus (`prometheus.yml`)

- [ ] Job `ledger-service` com intervalo de scraping de `5s`
- [ ] Target apontando para `/actuator/prometheus` da aplicação

### AC-3: Dashboard no Grafana (`dashboards/ledger-dashboard.json`)

- [ ] **Painel 1 — Vazão HTTP:** RPS por status HTTP (`http_server_requests_seconds_count`)
- [ ] **Painel 2 — Latência de Cauda:** Percentis `p95` e `p99` de `/api/v1/payments/transfer`
- [ ] **Painel 3 — Saturação do Pool:** HikariCP conexões ativas (`hikaricp_connections_active`), ociosas (`hikaricp_connections_idle`), pendentes (`hikaricp_connections_pending`)
- [ ] **Painel 4 — Memória JVM:** Heap usado (`jvm_memory_used_bytes{area="heap"}`)

### AC-4: Script de Teste de Carga (`scripts/load-test.js`)

- [ ] Script **k6** com 50-100 VUs concorrentes contra `/api/v1/payments/transfer`
- [ ] Header `X-Idempotency-Key` em cada requisição de pagamento
- [ ] Threshold: `http_req_failed < 0.01` (< 1% falha)
- [ ] Threshold: `http_req_duration{p(95)<500}` (p95 < 500ms)

## Scope

- Scraping `/actuator/prometheus`, `prometheus.yml` config, Grafana Dashboard import (RPS, Latency p95/p99, HikariCP pool), k6 concurrency testing proving no database starvation
- **Out of scope:** Jaeger Distributed Tracing, OpenTelemetry Collector, complex Chaos Engineering, Elasticsearch/ELK clusters

## Study Needed

- [ ] Spring Boot Actuator Metrics with Micrometer
- [ ] Prometheus Configuration Documentation
- [ ] Grafana Dashboards Best Practices
- [ ] k6 Load Testing Documentation

## References

- [Spring Boot Actuator Metrics](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html#actuator.metrics)
- [Prometheus Configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
- [Grafana Dashboards](https://grafana.com/docs/grafana/latest/dashboards/)
- [k6 Documentation](https://k6.io/docs/)

## Validation

```bash
python3 stages-labs/spring-cloud-platform/05-observability/verify.py
```

---

**Prev:** [[04-github-actions]]
**Board:** [[BOARD]]
