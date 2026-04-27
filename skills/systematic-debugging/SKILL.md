---
name: systematic-debugging
description: |
  Invoke when the user faces a broken or misbehaving system and doesn't know the root cause yet. Classic triggers: a service throws 500s or crashes, an endpoint is slow or times out, memory keeps growing, a test or feature that worked yesterday now fails, something works locally but breaks in production, a component doesn't render or behave as expected despite attempted fixes. Also invoke when the user explicitly says they've tried multiple things and it still doesn't work — that's the clearest signal. Provides structured root-cause methodology: reproduce first, trace backward from the symptom, hypothesize once, verify. Skip for: new feature requests, proactive refactoring, writing tests upfront, code review, or pure explanations.
author: Gonzalo Astudillo
version: 1.1.0
date: 2026-04-14
user-invocable: true
---

# Systematic Debugging

## The Iron Law

**NO FIXES WITHOUT REPRODUCTION FIRST.**

Reading code reveals what *could* happen. Running code reveals what *actually* happens. Never propose a fix based on code analysis alone.

## The Three Phases

### Phase 1: Reproduce & Observe
1. Read the error message thoroughly — the answer is often there
2. Write a minimal throwaway script that triggers the failure
3. Execute it — document what actually happens (not what you expect)
4. Add logging at key points
5. Narrow scope through bisection

**Do not read multiple files before running anything.**

### Phase 2: Root Cause Analysis
Only after observing where it breaks:
1. Read the relevant code — trace backward from the symptom to the source
2. Where does the bad value originate?
3. Check recent git history chronologically (not by keyword)
4. Compare working vs broken implementations

**The loudest component is often not the culprit.** In multi-layer systems, silent resource consumers (slow queries, connection drains) cause timeouts downstream — the component throwing errors may be a victim, not the cause.

### Phase 3: Fix & Verify
1. State one specific hypothesis
2. Make minimal, isolated changes
3. Convert the reproduction script into a lasting test
4. Verify comprehensively — not just the happy path

## The 3-Fix Rule

Three failed fix attempts = architectural problem. Stop. Discuss with stakeholders before attempting more patches.

## Red Flags — Stop and Restart

- Reading multiple files before running anything
- Proposing a fix from code analysis alone
- Fixing the error location instead of the root cause
- Attempting a 4th fix after 3 failures
- Adding logging after the fact instead of before

### Phase 4 (Optional): Document as GitHub Issue

After Phase 3, if the fix is non-trivial or should be tracked, ask:

> "¿Convertimos esto en un GitHub issue?"

If yes, generate an issue with this structure:

- **Title**: `[Bug] <concise description of the broken behavior>`
- **Problem**: What breaks, under what conditions, and the root cause found in Phase 2
- **Root Cause**: The specific function/invariant/assumption that failed
- **TDD Fix Plan**: Ordered RED-GREEN cycles
  - 🔴 RED: a test that captures the broken behavior (fails today)
  - 🟢 GREEN: the minimal code change to make it pass
  - Repeat for each distinct behavior that needs fixing
- **Acceptance Criteria**: Observable behaviors that must hold after the fix
- **Out of Scope**: What this fix deliberately does NOT address

Use behavior descriptions, not file paths — file paths rot. Describe contracts and invariants.

## Supporting Files

- **root-cause-tracing.md** — How to trace backward through the call chain
- **defense-in-depth.md** — Validation at each layer to catch problems early
