---
name: compound-component
description: |
  Compound Component pattern for composable, flexible React UI. Context + dot notation.
  Use when: building UI with shared implicit state, flexible slot-based APIs, design system components.
  Trigger on: "compound component", "componente composable", "context UI", "dot notation component",
  "Card.Header", "flexible component API", "Radix-style", "Headless UI pattern".
author: Gonzalo Astudillo
version: 1.0.0
date: 2026-04-14
user-invocable: true
---

# Compound Component Pattern

## What It Is

A pattern for building components that share implicit state through Context, exposed as a group with dot notation:

```tsx
<Card>
  <Card.Header>Title</Card.Header>
  <Card.Body>Content here</Card.Body>
  <Card.Footer>Actions</Card.Footer>
</Card>
```

Used by: Radix UI, Headless UI, Reach UI, shadcn/ui.

## When to Use

✅ UI with **shared state between sub-parts** (e.g., Accordion knows which item is open)
✅ Components with **flexible slot-based APIs** (reorder parts, omit parts)
✅ **Design system components** where consumers customize structure
✅ When you want to avoid "prop drilling" for internal display state

## When NOT to Use

❌ Simple components with no shared state — just use props
❌ Components that are always rendered in a fixed structure
❌ When the component has only one meaningful child

## Implementation (TypeScript)

```tsx
// card.tsx
import { createContext, useContext, ReactNode } from "react"

// 1. Define the context type
interface CardContext {
  variant?: "default" | "bordered" | "elevated"
}

// 2. Create context (null = not inside Card)
const CardContext = createContext<CardContext | null>(null)

// 3. Hook to access context with error boundary
function useCardContext() {
  const ctx = useContext(CardContext)
  if (!ctx) throw new Error("Card sub-components must be used inside <Card>")
  return ctx
}

// 4. Root component — provides context
function Card({ children, variant = "default" }: { children: ReactNode; variant?: CardContext["variant"] }) {
  return (
    <CardContext.Provider value={{ variant }}>
      <div className={`card card--${variant}`}>{children}</div>
    </CardContext.Provider>
  )
}

// 5. Sub-components — consume context
function Header({ children }: { children: ReactNode }) {
  const { variant } = useCardContext()
  return <div className={`card__header card__header--${variant}`}>{children}</div>
}

function Body({ children }: { children: ReactNode }) {
  useCardContext()  // validates usage even if variant isn't needed
  return <div className="card__body">{children}</div>
}

function Footer({ children }: { children: ReactNode }) {
  useCardContext()
  return <div className="card__footer">{children}</div>
}

// 6. Attach sub-components with dot notation
Card.Header = Header
Card.Body = Body
Card.Footer = Footer

export { Card }
```

## Usage

```tsx
// Consumer has full control over structure
<Card variant="bordered">
  <Card.Header>User Profile</Card.Header>
  <Card.Body>
    <Avatar src={user.avatar} />
    <p>{user.bio}</p>
  </Card.Body>
  <Card.Footer>
    <Button>Follow</Button>
  </Card.Footer>
</Card>

// Can omit parts
<Card>
  <Card.Body>Simple card with no header</Card.Body>
</Card>

// Can reorder (if design allows)
<Card>
  <Card.Footer>Top actions</Card.Footer>
  <Card.Body>Content</Card.Body>
</Card>
```

## TypeScript: Typing the Compound Component

```tsx
// Add sub-components to the type
interface CardComponent {
  (props: { children: ReactNode; variant?: CardContext["variant"] }): JSX.Element
  Header: typeof Header
  Body: typeof Body
  Footer: typeof Footer
}

const Card = function Card(...) { ... } as CardComponent
Card.Header = Header
// etc.
```

## Supporting Files

- **examples.md** — Full examples: Accordion, Tabs, Select, Modal
