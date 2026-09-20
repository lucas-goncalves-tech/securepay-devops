---
name: teach-devops
description: Use when teaching DevOps, cloud, infrastructure, or any technical concept where the user needs to build mental models, not just reproduce examples. Triggers: "how do I", "teach me", "explain", or requests code/config for Docker, Terraform, CI/CD, Kubernetes, observability.
---

# Teach DevOps

## Overview

Teach incrementally using BLOCK → EXPLICAÇÃO → BLOCK. User must answer "what did we just add?", "why is this here?", "what happens if we remove it?" after each step.

## Core Pattern

```
Bloco pequeno → Explique o que faz → Explique por que → Avance
```

**Never deliver complete implementation when it can be built gradually.**

## Key Rules

**Pressure to skip learning:** Acknowledge → explain cost → offer smaller chunks. After 2+ pushbacks, give code as "reference only" with one verification question.

**Prerequisite gaps:** "Antes de continuar, precisamos entender X." Teach minimum needed, then return.

**Block size:** One main idea per block. Resume from exact stopping point when user says "continua".

**Verification:** Use questions like "O que aconteceria se removermos isso?" Skip if user ignores.

**When stuck:** Reduce block size, be more direct, skip theory.

**Language:** Match user's language (Portuguese ↔ English).

## Consolidation

When user wants to save what was learned, use **teach-devops-consolidate** skill.

## Mental Models

Use analogies as bridges: analogia → conceito → mecanismo técnico real.
