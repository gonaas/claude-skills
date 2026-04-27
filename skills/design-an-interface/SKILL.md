---
name: design-an-interface
description: |
  "Design It Twice" methodology for APIs, modules, and contracts. Launches parallel sub-agents
  with opposing constraints to explore radically different designs before committing to one.
  Use when: designing an API, module interface, data contract, or any public-facing surface.
  Trigger on: "diseña la interfaz", "cómo debería ser X", "qué API usar", "diseña el contrato",
  "design an interface", "design the API", "what should the interface look like".
author: Gonzalo Astudillo
version: 1.0.0
date: 2026-04-27
user-invocable: true
---

# Design an Interface

## The Principle

**Your first idea is rarely the best.** Before committing to a design, explore radically different alternatives. The goal is a *deep module* — a simple interface that conceals substantial complexity.

> Shallow interface: many methods, little hidden = complexity leaks to callers.
> Deep module: few methods, much hidden = callers stay simple.

## When to Use

Use this skill *after* `/shaping` has defined what problem to solve and *before* implementing. It answers: given the problem is scoped, **what should the contract look like?**

```
/shaping  →  what to build (macro)
/design-an-interface  →  how the contract should look (micro)
```

## Workflow

### Step 1: Gather Requirements

Before generating alternatives, clarify:
- What problem does this interface solve?
- Who calls it? (other modules, external clients, tests)
- What operations must it support?
- What complexity should it hide internally?
- What must NOT leak through the interface?

Ask only what's missing — don't interview if the context is already clear.

### Step 2: Launch 3 Sub-Agents in Parallel

Spawn three sub-agents simultaneously, each with a different constraint:

**Sub-Agent A — Minimal Surface**
Constraint: minimize the number of methods/parameters. If in doubt, leave it out.
Goal: find the smallest API that still solves the problem.

**Sub-Agent B — Maximum Flexibility**
Constraint: make every behavior configurable and extensible.
Goal: find the most adaptable API that anticipates future needs.

**Sub-Agent C — Golden Path Optimization**
Constraint: optimize for the single most common use case. Make that case trivially easy, even if edge cases are harder.
Goal: find the most ergonomic API for the 80% scenario.

Each sub-agent must produce:
1. The interface signature (types, method names, parameters)
2. A concrete usage example (2-3 lines of calling code)
3. What complexity it hides internally
4. What it deliberately does NOT support

### Step 3: Present All Three Designs

Show each design side by side. For each:
- Signature
- Usage example
- Hidden complexity
- Limitations

### Step 4: Compare on 4 Dimensions

| Dimension | Design A | Design B | Design C |
|---|---|---|---|
| Simplicity | | | |
| Generality | | | |
| Implementation cost | | | |
| Module depth | | | |

### Step 5: Recommend

Choose one design (or synthesize the best elements) and explain:
- Why it wins on the most important dimension
- What tradeoffs you're accepting
- What you'd change if requirements shifted

## Output Format

End with a single code block showing the recommended interface, ready to be used as the starting point for implementation.

## Relationship with Other Skills

- Run `/shaping` first to define the problem scope
- Run `/tdd` after to implement with tests that verify the chosen interface
- Run `/domain-model` if the interface involves domain concepts that need precise language
