# Design for Testability

## Core Principle: Deep Modules

Build modules with **small interface + deep implementation**. Hide complexity behind simple APIs.

## Three Interface Design Rules

### 1. Dependency Injection
Accept dependencies as parameters instead of instantiating them internally.

```ts
// Bad — untestable
function processPayment(amount: number) {
  const stripe = new StripeClient()  // hidden dependency
  return stripe.charge(amount)
}

// Good — testable
function processPayment(amount: number, client: PaymentClient) {
  return client.charge(amount)
}
```

### 2. Pure Functions
Return results, don't produce side effects. Verify behavior through assertions, not state inspection.

```ts
// Bad — mutates input + side effects
function applyDiscount(order: Order, service: PricingService) {
  order.price = service.calculate(order.price)  // mutation
}

// Good — pure, returnable, testable
function applyDiscount(price: number, discountFn: (p: number) => number): number {
  return discountFn(price)
}
```

### 3. Minimal Surface Area
Fewer public methods = fewer test cases = simpler setup. If a method doesn't need to be public, make it private.

## Refactoring Signals (after going GREEN)

Watch for these after tests pass — they indicate design issues:

| Signal | Action |
|---|---|
| Code duplication | Extract into reusable unit |
| Long methods | Break into focused private helpers |
| Shallow modules | Combine or deepen them |
| Logic in wrong class | Move to data owner |
| Primitive obsession | Wrap in domain objects |

## When Design Resists Testing

If writing a test feels impossible, the design is wrong — not the test approach. Testability is a design quality signal. Hard-to-test code = hard-to-change code.
