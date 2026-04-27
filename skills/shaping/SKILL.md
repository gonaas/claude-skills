---
name: shaping
description: |
  Use when someone has a feature requirement or goal but needs to figure out the approach and scope before writing code. The user knows WHAT they want but not HOW to bound or structure the work. Signals: "how do I approach X?", "where do I start with Y?", "help me scope/plan Z", "the client/PM wants W — what do we do?", "cómo lo abordo", "por dónde empiezo", "qué enfoque tomamos", "ayúdame a acotarlo". This applies even when the query starts with "I need to implement X" — if they're asking how to tackle it rather than asking you to do it, use this skill. Skip when the path is already clear and the user wants execution: fix this bug, write this endpoint, optimize this query, configure this tool, review this PR.
author: Gonzalo Astudillo
version: 1.0.0
date: 2026-04-14
user-invocable: true
---

# Shaping — Design Before Implementation

## The Iron Law

**NO IMPLEMENTATION BEFORE ALIGNMENT.**

Never write code until the problem is defined, options are evaluated, and a recommendation is chosen. Starting to code without alignment wastes everyone's time.

## The Five Phases

### Phase 1: Investigate
Silently read the codebase. Understand existing patterns, connections, and affected systems.
- Verify by running, not just reading — use throwaway scripts or grep
- Never assume runtime behavior

### Phase 2: Problem
Define WHAT is needed as numbered requirements:
- Describe outcomes and constraints, never implementations
- Interview depth-first — one decision at a time
- Establish acceptance criteria as observable behavior

### Phase 3: Options
Present 2–3 concrete approaches in a comparison table:

| Criteria | Option A | Option B | Option C |
|---|---|---|---|
| Requirement 1 | ✅ | ✅ | ❌ |
| Requirement 2 | ✅ | ❌ | ✅ |
| Unknowns | — | ⚠️ | — |

**If all options pass but one feels wrong — there's a missing requirement. Find it.**

### Phase 4: Recommend
Present your recommendation with reasoning **before** waiting for choice. Do not proceed until the user decides.

### Phase 5: Slice
Break work into **vertical slices** — each slice cuts through all layers (data + logic + UI). Never horizontal (all DB migrations, then all API, then all UI).

Every implementation ends with a **Verification** section describing observable behavior beyond passing tests.

## Critical Rules

- One decision per message — depth-first, not breadth-first
- Challenge with evidence from the codebase, not assumptions
- Spike unknowns that would change your recommendation before presenting options
- Scale to task size: one sentence for trivial tasks, full doc for architectural changes
