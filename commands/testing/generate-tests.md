---
allowed-tools: Read, Write, Edit, Bash
argument-hint: [file-path] | [--tdd component-name]
description: Generate tests for a file or component. Use when the user explicitly asks to write, create, or generate tests for a specific file or component. Supports two modes — TDD mode (use --tdd flag, or when the target file does not exist yet: generates exactly ONE minimal failing test before implementation, as the RED step) and coverage mode (file already exists: generates a full test suite). When the tdd skill is active and the user asks to implement a new feature from scratch, suggest /generate-tests --tdd <name> as the RED step before writing any code.
---

# Generate Tests

Target: $ARGUMENTS

## Mode Detection

Before generating anything, determine which mode applies:

- If `$ARGUMENTS` starts with `--tdd` → **TDD mode** (extract component name after the flag)
- If `$ARGUMENTS` is a file path that does not exist → **TDD mode**
- If `$ARGUMENTS` is a file path that exists → **Coverage mode**
- If `$ARGUMENTS` is a component name with no file path → check if a matching file exists; if not, ask the user which mode they want

---

## TDD Mode — RED Step

The goal is a single, minimal, failing test that describes one concrete behavior. Nothing more.

**Why one test:** TDD cycles one behavior at a time. Writing a full suite before the code exists is design fiction — the tests encode assumptions that may be wrong. One test forces a decision about the first real behavior.

Steps:
1. Read any context available (related files, interfaces, type definitions) to understand what the component should do
2. Identify the **single most important behavior** to drive the implementation
3. Write exactly one test for that behavior — minimal setup, one assertion, clear name
4. Run the test suite to confirm this test fails:
   ```bash
   # detect runner
   npx jest --testPathPattern="<test-file>" 2>&1 | tail -20 \
     || npx vitest run "<test-file>" 2>&1 | tail -20 \
     || python -m pytest "<test-file>" -v 2>&1 | tail -20
   ```
5. If the test passes before any implementation exists, the test is wrong — revise it

End with this message to the user:
> **RED step complete.** This test fails. Now write the minimum code to make it pass (GREEN step). Once it passes, run `/generate-tests <file-path>` to fill in edge cases and integration tests.

**Never generate more than one test in TDD mode.**

---

## Coverage Mode — Full Test Suite

Generate comprehensive tests for existing code in `$ARGUMENTS`.

### Setup Check

- Test framework: !`cat package.json 2>/dev/null | grep -E '"jest"|"vitest"|"mocha"|"jasmine"' | head -3 || cat jest.config.* vitest.config.* 2>/dev/null | head -5 || echo "Framework not detected"`
- Existing tests: !`find . -name "*.test.*" -o -name "*.spec.*" | head -5`
- Target file: @$ARGUMENTS

### Generation Framework

1. **Analyze** — identify all exported functions, classes, methods, and their signatures
2. **Strategy** — examine existing test patterns; choose unit vs integration scope; identify critical paths and error scenarios
3. **Mock Design** — map all external dependencies (I/O, APIs, timers, dates); only mock at system boundaries (external APIs, databases, file system, time). Never mock your own code — if you feel the urge to mock an internal module, the design needs refactoring. See `mocking.md` in the tdd skill for the full decision tree.
4. **Unit Tests** — write isolated tests per function/method covering happy path, edge cases, and error conditions; follow AAA pattern (Arrange, Act, Assert)
5. **Integration Tests** — test component interactions, API layers with mocked responses, and end-to-end user workflows where applicable
6. **Quality Check** — verify naming describes behavior not implementation; confirm 80%+ coverage on critical business logic; ensure test isolation

### Framework-Specific Guidance

- **React**: Component testing with React Testing Library; test user interactions and rendering
- **Vue**: Component testing with Vue Test Utils; test props, events, and slots
- **Angular**: Component and service testing with TestBed; test dependency injection
- **Node.js**: API endpoint and middleware testing; test request/response cycles
- **Python**: `pytest` with fixtures, `unittest.mock` for patching, `pytest-cov` for coverage
- **Go**: Table-driven tests in `_test.go` files, `testify/assert` for assertions, subtests via `t.Run()`
- **Rust**: `#[cfg(test)]` modules, `#[test]` attributes, `mockall` for mocking

### Best Practices

- AAA pattern (Arrange, Act, Assert)
- 80%+ coverage; prioritize critical business logic and error paths
- Mock only external I/O; use factories for test data
- Test names describe behavior, not implementation details

> **Note:** If this code had no tests before, consider using TDD on the next feature — write the test first with `/generate-tests --tdd <component-name>` before writing any implementation code.
