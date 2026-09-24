---
aliases: [issue-12, kubernetes-helm]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-2-micro-k8s
prioridade: media
---

# Issue #12: Kubernetes Local Multi-Node com Helm Chart

## Objetivo

Portar a plataforma para orquestrador real com chart versionado, probes e limites declarados.

## O que fazer

### Etapa 1 — Cluster e chart

**INÍCIO:** tudo fora de orquestrador.

- [ ] Subir cluster local multi-node para simular falha de nó
- [ ] Empacotar plataforma como chart único com valores por ambiente

**FIM:** chart instala em qualquer namespace de teste.

---

### Etapa 2 — Saúde e recursos

**INÍCIO:** pods sem probe nem limite.

- [ ] Declarar probes (startup, liveness, readiness) por serviço
- [ ] Declarar requests e limits de CPU e memória

**FIM:** probe errada detectada em teste; OOM contido.

---

### Etapa 3 — Rollout

**INÍCIO:** deploy sem estratégia.

- [ ] Validar rollout, rollback e restart sem downtime visível

**FIM:** falha de nó não derruba tudo; rollback volta sozinho.

## O que aprender

### Aprender A — K8s base

- [ ] Pod, Deployment, Service, probes, resources
  - https://kubernetes.io/docs/concepts/
  - https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

**FIM:** sei explicar cada probe.

---

### Aprender B — Helm e cluster local

- [ ] Charts e values
  - https://helm.sh/docs/
- [ ] Multi-node local
  - https://kind.sigs.k8s.io/

**FIM:** sei versionar chart por ambiente.

## Critério de pronto

1. [ ] Nó falho não derruba plataforma
2. [ ] Rollback limpo
3. [ ] Probes justificadas

---

**Prev:** [[11-devsecops-gates]]
**Next:** [[13-aws-production]]
**Board:** [[BOARD]]
