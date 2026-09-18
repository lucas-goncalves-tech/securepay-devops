---
aliases: [board, kanban, status]
tags: [tracker, board]
---

# SecurePay DevOps — Board

> Kanban profissional DevSecOps. Sem paths, sem comandos copy-paste.
> 1 card por estágio. Foco: transformar o backend em plataforma profissional.
> Ordem sugerida: 03 → 06 → 07 → 08 → 04 → 05 → 09 → 10 → 11 → 12 → 13 → 14 → 15 → 16 → 17

## Done

- [x] [[01-linux-runtime|01 Linux Runtime]] — runtime, env, healthcheck L4/L7, SIGTERM
- [x] [[02-docker-compose|02 Docker Compose]] — imagem enxuta non-root, compose com dependência saudável

## Doing

- [ ] _vazio — puxe `03-terraform-vpc` para cá ao iniciar_

## To Do

### Trilha 1 — Core (SecurePay)

- [ ] [[03-terraform-vpc|03 Terraform VPC]] — rede multi-tier, SGs encadeados, storage privado
- [ ] [[04-github-actions|04 GitHub Actions]] — CI backend, scan Trivy, gate IaC, FinOps staging
- [ ] [[05-observability|05 Observability]] — métricas Prometheus, Grafana p95/p99, carga k6

### Ponte DevSecOps (03→04)

- [ ] [[06-secrets-hygiene|06 Secrets Hygiene]] — higiene de segredos e baseline anti-vazamento
- [ ] [[07-sast-semgrep|07 SAST Semgrep]] — análise estática com regras bloqueantes
- [ ] [[08-pipeline-hardening|08 Pipeline Hardening]] — least-privilege e pinagem por SHA

### Trilha 2 — Microsserviços, K8s e Nuvem

- [ ] [[09-containers-redis|09 Containers e Redis]] — multi-service, streams e webhook gateway
- [ ] [[10-devsecops-gates|10 DevSecOps Gates]] — quality gates Gitleaks + SAST + SCA
- [ ] [[11-kubernetes-helm|11 Kubernetes Helm]] — cluster local multi-node e chart versionado
- [ ] [[12-aws-production|12 AWS Production]] — backend remoto de estado com lock e computação real

### Trilha 3 — VPS Econômica Produção

- [ ] [[13-vps-hardening|13 VPS Hardening]] — SSH key-only, firewall, fail2ban, swap
- [ ] [[14-caddy-reverse-proxy|14 Caddy Reverse Proxy]] — gateway L7 com TLS automático
- [ ] [[15-compose-isolation|15 Compose Isolation]] — redes internas, limites anti-OOM, DB blindado
- [ ] [[16-db-backups-s3|16 DB Backups S3]] — backup off-site com retenção e restore testado
- [ ] [[17-cicd-vps-deploy|17 CI/CD VPS Deploy]] — gates + deploy contínuo via SSH
