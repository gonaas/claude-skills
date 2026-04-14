# Root Cause Tracing

## Core Strategy

**Trace backward through the call chain until you find the original trigger, then fix at the source.**

Never patch where the error visibly occurs. Find what upstream code provided the bad input.

## The Four Steps

1. **Identify the symptom** — where the error manifests (may be a victim, not the cause)
2. **Locate the immediate cause** — the function that failed
3. **Determine what called it** — walk up the call stack with the problematic data
4. **Find the original trigger** — the root source of the bad value

## Example

```
Error: git init failed in /tmp/test-repo
  at GitClient.init (git.ts:45)
  at TestSetup.prepare (setup.ts:12)
  at beforeEach hook
```

Naive fix: patch `git.ts:45`. Wrong.

Tracing backward: `beforeEach` → `TestSetup.prepare` → `GitClient.init` receives `""` as path → `context.tmpDir` was `""` because it was initialized before `beforeEach` ran.

**Root cause:** initialization order. Fix at the setup level, not at git.ts.

## When Manual Tracing Is Blocked

Add diagnostic logging before the failure point:

```ts
// Use console.error in tests — loggers may suppress output
console.error("Debug context:", {
  path: context.tmpDir,
  cwd: process.cwd(),
  stack: new Error().stack
})
```

Include: variable values, directory paths, environment state, full stack trace.

## Test Pollution

If a bug only appears when tests run in a certain order, it's a shared state pollution problem. Use the `find-polluter.sh` script to identify which test corrupts the state.

```bash
# Binary search for the polluting test
./find-polluter.sh "failing-test-name"
```
