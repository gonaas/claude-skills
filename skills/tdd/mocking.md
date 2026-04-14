# Mocking Strategy

## When to Mock: System Boundaries Only

Mock only at the edges where your code interacts with systems you don't control:

| Mock this | Don't mock this |
|---|---|
| External APIs (Stripe, Twilio, SendGrid) | Your own internal modules |
| Databases (prefer real test DB) | Internal dependencies you wrote |
| Time / randomness (`Date.now`, `Math.random`) | Pure functions |
| File system (in some cases) | Anything within your control |

**Never mock your own code.** If you're mocking an internal module, the design needs refactoring (see design.md).

## Design Pattern: SDK-Style Interfaces

Structure injectable dependencies with specific, purpose-built methods rather than generic fetchers.

```ts
// Bad — generic, hard to mock cleanly
interface DataService {
  fetch(resource: string, params: unknown): Promise<unknown>
}

// Good — SDK-style, each mock returns one specific shape
interface UserService {
  getUser(id: string): Promise<User>
  updateUser(id: string, data: Partial<User>): Promise<User>
  deleteUser(id: string): Promise<void>
}
```

Benefits of SDK-style:
- Each mock returns exactly one shape — no conditional logic in test setup
- Type safety catches mock/implementation drift
- Test coverage is transparent (one method = one test concern)

## Implementation Pattern

```ts
// Dependency injection makes mocking trivial
function createOrderHandler(users: UserService, payments: PaymentService) {
  return async function handleOrder(userId: string, amount: number) {
    const user = await users.getUser(userId)
    return payments.charge(user.paymentMethodId, amount)
  }
}

// In tests
const mockUsers: UserService = { getUser: async () => fakeUser, ... }
const mockPayments: PaymentService = { charge: async () => fakeCharge, ... }
const handler = createOrderHandler(mockUsers, mockPayments)
```

## Before Mocking — Checklist

1. Is this a system boundary? (external API, DB, time) → Mock it
2. Is this my own code? → Refactor instead
3. Is the mock setup more complex than the test? → Use real components
4. Am I testing behavior or mock existence? → If mock existence, delete the test
