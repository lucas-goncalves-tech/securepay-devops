---
aliases: [issue-11, kubernetes-helm]
tags: [tracker, issue, todo, study-needed]
status: todo
trilha: trilha-2-micro-k8s
prioridade: media
---

# Issue #11: Kubernetes Local Multi-Node com Helm Chart

## Objetivo

Portar a plataforma para orquestrador real com chart versionado, probes e limites declarados.

## O que fazer

- [ ] Subir cluster local multi-node para simular falha de nó
- [ ] Empacotar plataforma como chart único com valores por ambiente
- [ ] Declarar probes (startup, liveness, readiness) por serviço
- [ ] Declarar requests e limits de CPU e memória
- [ ] Validar rollout, rollback e restart sem downtime visível

## O que aprender

- [ ] Conceitos K8s: Pod, Deployment, Service, probes, resources
  - https://kubernetes.io/docs/concepts/
  - https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
- [ ] Helm charts e values
  - https://helm.sh/docs/
- [ ] Cluster local multi-node
  - https://kind.sigs.k8s.io/

## Critério de pronto

- Falha de um nó não derruba todos os serviços
- Rollback volta versão anterior sem intervenção manual obscura
- Sei explicar por que probe errada derruba serviço saudável

---

**Prev:** [[10-devsecops-gates]]
**Next:** [[12-aws-production]]
**Board:** [[BOARD]]
