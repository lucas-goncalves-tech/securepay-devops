# 📊 Estágio 05: Observabilidade, Métricas de Produção e Confiabilidade (SRE)

> **RFC-005:** Telemetria em Tempo Real, Monitoramento de Pool de Conexões e Testes de Carga.  
> **Objetivo Técnico:** Transformar uma API em um sistema observável em tempo real, monitorando métricas de saturação de banco de dados e latência percentílica sob concorrência.

---

## 🎯 Contexto do Problema

Durante períodos de alto tráfego, microsserviços enfrentam problemas de degradação que métricas básicas de infraestrutura (como uso de CPU e memória RAM) não conseguem diagnosticar:
1. **Falta de visibilidade do comportamento interno:** Falta de telemetria para identificar se a lentidão decorre de pausas de Garbage Collection na JVM, saturação de threads HTTP ou contenção no banco de dados.
2. **Esgotamento do Pool de Conexões (HikariCP Starvation):** Todas as conexões do pool ficam ocupadas com consultas lentas, fazendo com que novas requisições fiquem retidas em fila até atingirem o timeout (`connection-timeout: 20s`), disparando erros 500.
3. **Métricas médias ilusórias:** O tempo médio de resposta pode parecer satisfatório (ex: 120ms), enquanto clientes na cauda percentílica (`p95` e `p99`) sofrem com latências superiores a 5 segundos.

Neste estágio, você vai configurar a coleta de métricas com o **Prometheus**, criar um painel analítico no **Grafana** baseado nos *Golden Signals* e validar a resiliência do sistema com um **teste de carga automatizado (k6)**.

---

## 📋 Critérios de Aceite

> Cada item abaixo é um checkbox independente que espelha uma asserção do oráculo (`verify.py`). Abra o accordion só da task atual.

- [ ] **Orquestração de Observabilidade (`app/ledger-service/docker-compose.observability.yml`):**
  <details>
  <summary>ver detalhes</summary>

  - Declarar serviço do **Prometheus** (`prom/prometheus:latest`) expondo a porta `9090:9090` e montando o arquivo `prometheus.yml`.
  - Declarar serviço do **Grafana** (`grafana/grafana:latest`) expondo a porta `3000:3000`.
  - Garantir comunicação em rede entre o Prometheus e a API `ledger-service`.
  - O oráculo aceita como fallback a pasta do estágio (`stages-labs/spring-cloud-platform/05-observability/`) ou `infra/ledger-service/observability/`.

  </details>

- [ ] **Configuração de Coleta do Prometheus (`app/ledger-service/prometheus.yml`):**
  <details>
  <summary>ver detalhes</summary>

  - Declarar o job `ledger-service` com intervalo de scraping de `5s`.
  - Configurar a coleta direcionada ao endpoint `/actuator/prometheus` da aplicação.

  </details>

- [ ] **Dashboard Corporativo no Grafana (`app/ledger-service/dashboards/ledger-dashboard.json`):**
  <details>
  <summary>ver detalhes</summary>

  - **Painel 1 (Vazão HTTP):** Taxa de Requisições por Segundo (RPS) segmentada por status HTTP (`http_server_requests_seconds_count`).
  - **Painel 2 (Latência de Cauda):** Percentis `p95` e `p99` das rotas de transferência (`/api/v1/payments/transfer`).
  - **Painel 3 (Saturação do Pool de Banco):** Estado do pool HikariCP monitorando conexões ativas (`hikaricp_connections_active`), ociosas (`hikaricp_connections_idle`) e pendentes (`hikaricp_connections_pending`).
  - **Painel 4 (Uso de Memória):** Consumo de memória Heap da JVM (`jvm_memory_used_bytes{area="heap"}`).

  </details>

- [ ] **Script de Teste de Carga e Resiliência (`app/ledger-service/scripts/load-test.js`):**
  <details>
  <summary>ver detalhes</summary>

  - Implementar script para o **k6** simulando entre 50 e 100 usuários virtuais concorrentes disparando requisições contra `/api/v1/payments/transfer`.
  - Incluir o cabeçalho `X-Idempotency-Key` nas requisições de pagamento para exercitar os mecanismos de integridade e locks concorrentes.
  - Configurar thresholds de qualidade:
    * Taxa de requisições com falha inferior a 1% (`http_req_failed < 0.01`).
    * Latência no percentil `p95` inferior a 500 milissegundos (`http_req_duration{p(95)<500}`).

  </details>

---

## 🚧 Fronteira de Não-Escopo

- ❌ **Proibido Cobrar:** Jaeger Distributed Tracing com OpenTelemetry Collector, Chaos Engineering complexo, clusters Elasticsearch/ELK.
- ✅ **Foco Exclusivo:** Scraping do `/actuator/prometheus`, configuração do `prometheus.yml`, importação de Dashboard no Grafana (RPS, Latência p95/p99, pool HikariCP) e simulação de concorrência com **k6** provando integridade sem starvation de banco.

---

## 📚 Documentação de Referência
- [Spring Boot Actuator Metrics with Micrometer](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html#actuator.metrics)
- [Prometheus Configuration Documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
- [Grafana Dashboards Best Practices](https://grafana.com/docs/grafana/latest/dashboards/)
- [k6 Load Testing Documentation](https://k6.io/docs/)

---

## ⚖️ Validação Mecânica (Oráculo)
Para validar os critérios deste estágio, execute no terminal:
```bash
python3 stages-labs/spring-cloud-platform/05-observability/verify.py
```
O estágio é considerado concluído quando todas as asserções retornarem `PASS` e o Exit Code for `0`.
