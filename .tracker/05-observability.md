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

- [ ] Orquestrar stack de observabilidade (coletor + dashboard) na mesma rede da API
- [ ] Expor métricas da aplicação via endpoint Prometheus do Actuator
- [ ] Configurar scraping em intervalo curto para o serviço ledger
- [ ] Criar dashboard com 4 painéis: vazão HTTP por status, latência p95/p99 do transfer, pool HikariCP, heap JVM
- [ ] Criar script de carga com dezenas de VUs contra endpoint de transferência com chave de idempotência
- [ ] Validar SLOs: taxa de erro < 1% e p95 abaixo do teto sob carga

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

- Dashboard mostra RPS, p95/p99, pool e heap em tempo real
- Carga com 50-100 VUs passa sem erro > 1% e sem starvation do banco
- Sei apontar no gráfico onde mora o gargalo (I/O, pool ou heap)

---

**Prev:** [[04-github-actions]]
**Next:** [[09-containers-redis]]
**Board:** [[BOARD]]
