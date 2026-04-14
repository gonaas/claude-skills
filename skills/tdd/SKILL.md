---
name: tdd
description: |
  Test-Driven Development. Iron Law: no production code without a failing test first.
  Use when: writing tests, TDD, test first, implementing features, fixing bugs, hotfix.
  Trigger on: "escribe tests", "TDD", "test first", "implementa feature", "arregla el bug", "bug fix".
author: Gonzalo Astudillo
version: 1.0.0
date: 2026-04-14
user-invocable: true
---

# TDD — Test-Driven Development

## The Iron Law

**No production code without a failing test first.** No exceptions — not for trivial fixes, not for hotfixes, not for "I already tested it manually." Throwaway scripts and investigation code are excluded. Everything else requires a preceding failing test.

## The Cycle

Work in vertical slices — one behavior at a time:

1. **RED** — Write one minimal failing test describing a single behavior. Watch it fail. If you didn't see it fail, you don't know if it tests the right thing.
2. **GREEN** — Write the simplest code that makes the test pass. Nothing more.
3. **REFACTOR** — Clean up only after tests pass. Never refactor on red.

Repeat for each behavior. Never write multiple tests at once before implementing.

## Bug Fix Protocol

Every bug fix, regardless of urgency:
1. Write a test that reproduces the bug — verify it fails
2. Apply the fix — verify the test passes
3. Ship

A failing test takes ~60 seconds and simultaneously proves the fix works and prevents regression.

## Common Rationalizations — All Rejected

| Excuse | Why it's wrong |
|---|---|
| "It's too simple to test" | Simple code breaks too. The test takes 30 seconds. |
| "I'll write tests after" | You won't. And you'll debug in production instead. |
| "I already tested it manually" | Manual tests don't prevent regressions. |
| "It's a hotfix/emergency" | Hotfixes without tests cause the next P0 incident. |
| "The framework handles it" | You're testing your code, not the framework. |

## Supporting Files

- **anti-patterns.md** — 5 common testing mistakes and how to fix them
- **design.md** — How to design code for testability (DI, pure functions, minimal surface)
- **mocking.md** — When and how to mock (only at system boundaries)

Read these files when Claude encounters those specific situations.
