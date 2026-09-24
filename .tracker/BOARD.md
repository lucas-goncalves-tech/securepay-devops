---
aliases: [board, kanban, status]
tags: [tracker, board]
---

# SecurePay DevOps — Board

> Kanban profissional DevSecOps. Sem paths, sem comandos copy-paste.
> Contexto consolidado em [[00-visao-geral|00 Visão Geral]] (pilares, E2E, metodologia).
> 1 card por estágio. Foco: transformar o backend em plataforma profissional.
> Ordem de execução: sequência numérica `01 → 18` — uma faixa por trilha.

## Done

- [x] [[01-linux-runtime|01 Linux Runtime]] — runtime, env, healthcheck L4/L7, SIGTERM
- [x] [[02-docker-compose|02 Docker Compose]] — imagem enxuta non-root, compose com dependência saudável

## Doing

- [ ] _vazio — puxe `03-terraform-vpc` para cá ao iniciar_

## To Do

### Trilha 1 — Core & DevSecOps (01–09)

- [ ] [[03-terraform-vpc|03 Terraform VPC]] — rede multi-tier, SGs encadeados, storage privado, ALB
- [ ] [[04-s3-reports-infra|04 S3 Reports Infra]] — bucket, IAM user, endpoint para relatórios financeiros
- [ ] [[05-github-actions|05 GitHub Actions]] — CI backend, scan Trivy, gate IaC, FinOps staging
- [ ] [[06-secrets-hygiene|06 Secrets Hygiene]] — higiene de segredos e baseline anti-vazamento
- [ ] [[07-sast-semgrep|07 SAST Semgrep]] — análise estática com regras bloqueantes
- [ ] [[08-pipeline-hardening|08 Pipeline Hardening]] — least-privilege e pinagem por SHA
- [ ] [[09-observability|09 Observability]] — métricas Prometheus, Grafana p95/p99, carga k6

### Trilha 2 — Microsserviços, K8s e Nuvem (10–13)

- [ ] [[10-containers-redis|10 Containers e Redis]] — multi-service, streams e webhook gateway
- [ ] [[11-devsecops-gates|11 DevSecOps Gates]] — quality gates Gitleaks + SAST + SCA
- [ ] [[12-kubernetes-helm|12 Kubernetes Helm]] — cluster local multi-node e chart versionado
- [ ] [[13-aws-production|13 AWS Production]] — backend remoto de estado com lock e computação real

### Trilha 3 — VPS Econômica Produção (14–18)

- [ ] [[14-vps-hardening|14 VPS Hardening]] — SSH key-only, firewall, fail2ban, swap
- [ ] [[15-caddy-reverse-proxy|15 Caddy Reverse Proxy]] — gateway L7 com TLS automático
- [ ] [[16-compose-isolation|16 Compose Isolation]] — redes internas, limites anti-OOM, DB blindado
- [ ] [[17-db-backups-s3|17 DB Backups S3]] — backup off-site com retenção e restore testado
- [ ] [[18-cicd-vps-deploy|18 CI/CD VPS Deploy]] — gates + deploy contínuo via SSH
