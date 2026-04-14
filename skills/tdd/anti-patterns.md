# TDD Anti-Patterns

Core principle: **"Test what the code does, not what the mocks do."**

## 1. Mock Behavior Testing
**Problem:** Asserting that mocks exist instead of checking real behavior.
```ts
// Bad
expect(mockService.fetch).toHaveBeenCalled()

// Good
expect(result).toEqual({ id: 1, name: "Alice" })
```
**Fix:** Test the actual output or side effect, not that a mock was called.

## 2. Test-Only Methods
**Problem:** Adding public methods to production code solely for testing.
```ts
// Bad — exposed only for tests
public getInternalState() { return this._state }
```
**Fix:** Move test utilities to dedicated test helper files. Never pollute production APIs.

## 3. Unmotivated Mocking
**Problem:** Mocking "to be safe" without understanding what side effect matters.
**Fix:** Before mocking, ask: "Does my test depend on this side effect?" If no, mock at a lower level or don't mock at all.

## 4. Incomplete Mock Objects
**Problem:** Partial mocks that omit fields from the real API.
```ts
// Bad — missing fields cause silent downstream failures
const mockUser = { id: 1 }

// Good — matches full API shape
const mockUser = { id: 1, name: "Alice", email: "a@b.com", role: "user" }
```
**Fix:** Mocks must match the complete API schema.

## 5. Overly Elaborate Mocks
**Problem:** Setup code exceeds test logic. Everything gets mocked just to make tests pass.
**Fix:** When setup becomes more complex than the test itself, consider integration tests with real components instead.

## Quick Diagnostic
Before mocking anything, ask:
1. Does my test depend on these side effects? → If no, mock at lower level
2. Is the setup more complex than the test? → Consider real components
3. Am I testing the mock or the code? → If the mock, delete the test
