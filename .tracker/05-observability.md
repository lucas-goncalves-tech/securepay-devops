---
aliases: [issue-05, observability, stage-05]
tags: [tracker, issue, todo, study-needed]
status: todo
stage: 05
rfc: RFC-005
---

# Issue #05: Observabilidade, Métricas de Produção e Confiabilidade (SRE)

## Acceptance Criteria

- [ ] Orquestração de Observabilidade (`docker-compose.observability.yml`)
- [ ] Configuração de Coleta do Prometheus (`prometheus.yml`)
- [ ] Dashboard Corporativo no Grafana (`ledger-dashboard.json`)
- [ ] Script de Teste de Carga e Resiliência (`load-test.js`)

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
