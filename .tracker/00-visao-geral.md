---
aliases: [visao-geral, overview, pilares]
tags: [tracker, overview]
---

# Visão Geral — Jornada do Local à Nuvem

> Fonte consolidada de contexto. Pastas de estágios e roadmap original foram removidos após migração.
> Este arquivo preserva metodologia, pilares e ciclo de vida sem referências a caminhos de arquivos.

## Jornada e público

- **Jornada:** da JVM no Linux local à plataforma corporativa com Docker, Terraform, CI/CD e observabilidade em tempo real.
- **Público:** desenvolvedor em transição para Junior DevOps / Cloud Platform Engineer e backend cloud-native.
- **Objetivo final:** transformar o backend em plataforma profissional DevSecOps (Trilha 1 — Core & DevSecOps, mais Trilhas 2–3). FinOps/entrevistas e Ansible estão fora de escopo por decisão.

## Metodologia (fim do tutorial purgatory)

Cada estágio é uma RFC / especificação de problema corporativo, sem receita copy-paste:

1. **Problema real do negócio:** desafio técnico da engenharia.
2. **Critérios de aceite:** comportamento observável (portas, HTTP, isolamento, shutdown).
3. **Documentação oficial primária:** Docker, Spring Boot, PostgreSQL, Terraform, Prometheus.
4. **Validação determinística:** suíte automatizada que audita sockets, HTTP e infra declarativa sem viés.

## Os 3 pilares do engenheiro maduro

1. **Fundamentos físicos:** redes L4 (socket TCP, handshake, conntrack) ao L7 (HTTP/1.1, HTTP/2, TLS, Keep-Alive, reverse proxy); gargalos de I/O e memória (IOPS gp3 vs gp2, fsync, Heap JVM vs RSS off-heap, page cache, OOMKilled cgroups v2).
2. **Negócio e confiabilidade preventiva:** FinOps (calcular custo antes de subir, desligar staging ocioso); prevenção acima de reação (shift-left, healthcheck real, tolerância a falhas).
3. **Automação intencional e KISS:** IaC declarativo idempotente e pipelines versionadas em vez de scripts ad-hoc; simplicidade, sem overengineering.

## Ciclo de vida E2E

1. **Código e runtime:** Spring Boot 3 Java 21 → runtime Linux (sockets, env) → SIGTERM gracioso.
2. **Empacotamento OCI:** multi-stage enxuto non-root → compose com dependência saudável.
3. **Infra declarativa:** Terraform VPC multi-tier + SGs + storage privado → banco isolado.
4. **Automação shift-left:** CI com testes Maven + Trivy + gate IaC + auto-stop de staging.
5. **Telemetria:** scraping Prometheus + Grafana p95/p99 e HikariCP + carga k6 sem starvation.

## Ordem de execução e política de status

- Ordem: `03 → 04 → 05 → 06 → 07 → 08 → 09 → 10 → 11 → 12 → 13 → 14 → 15 → 16 → 17 → 18` (sequência numérica; uma faixa por trilha).
- `01, 02, 03` Done; `04` é o próximo Doing.
- Cada card tem `## Fora de escopo` herdado dos contratos rígidos — respeitar para não antecipar ferramenta de estágio futuro.

---

**Board:** [[BOARD]]
