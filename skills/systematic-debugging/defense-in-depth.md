# Defense in Depth

## Principle

Validate at each layer of your system so bugs are caught as close to their origin as possible, not five layers downstream where the error is confusing.

## Validation Layers

```
User Input → API Layer → Service Layer → Data Layer → External Systems
    ↓             ↓            ↓              ↓
 Validate     Validate     Validate       Validate
 at entry     at API       at logic       at query
```

Each layer should validate its own assumptions, not trust that upstream layers did their job.

## Patterns

### 1. Fail Fast
Crash immediately on bad input rather than propagating bad state:

```ts
function processOrder(userId: string, amount: number) {
  if (!userId) throw new Error("userId is required")
  if (amount <= 0) throw new Error(`amount must be positive, got ${amount}`)
  // proceed
}
```

### 2. Assertion at Boundaries
Use assertions to document and enforce assumptions:

```ts
function applyDiscount(price: number, discount: number): number {
  console.assert(discount >= 0 && discount <= 1, `discount out of range: ${discount}`)
  return price * (1 - discount)
}
```

### 3. Type Narrowing Over Casting
Don't cast (`as Type`) — narrow with runtime checks:

```ts
// Bad
const user = data as User

// Good
if (!isUser(data)) throw new Error(`Expected User, got ${JSON.stringify(data)}`)
const user = data
```

## When a Bug Reaches Production

It means at least two layers failed: the code that introduced the bad value, and every layer that should have caught it. Fix the root cause AND strengthen the layer that let it through.
