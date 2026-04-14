---
name: systematic-debugging
description: |
  Systematic debugging methodology. Iron Law: NO FIXES WITHOUT REPRODUCTION FIRST.
  Use when: debugging, bug won't reproduce, error investigation, "no funciona", "falla", "error".
  Trigger on: "bug", "debug", "no funciona", "error", "falla", "se rompe", "investigate".
author: Gonzalo Astudillo
version: 1.0.0
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

## Supporting Files

- **root-cause-tracing.md** — How to trace backward through the call chain
- **defense-in-depth.md** — Validation at each layer to catch problems early
