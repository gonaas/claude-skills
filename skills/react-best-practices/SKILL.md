---
name: react-best-practices
description: |
  React and Next.js best practices from Vercel. Server Components by default, use client at the edge.
  Use when: building React components, Next.js features, data fetching, routing, performance.
  Trigger on: "componente React", "Next.js", "Vercel", "Server Component", "Client Component",
  "data fetching", "loading state", "metadata", "image", "font", "App Router".
author: Gonzalo Astudillo
version: 1.0.0
date: 2026-04-14
user-invocable: true
---

# React Best Practices (Next.js / Vercel)

## Golden Rule: Server Components by Default

Every component is a Server Component unless it needs:
- `useState` / `useReducer` / `useEffect`
- Browser-only APIs (`window`, `document`, `localStorage`)
- Event listeners (`onClick`, `onChange`)
- Third-party libraries that require client context

If none of the above → Server Component. No `"use client"`.

## `"use client"` Placement

Push `"use client"` **as deep as possible** — to the leaf that actually needs it, never to a layout or page.

```
// Bad — marks entire page as client
"use client"
export default function Page() { ... }

// Good — only the interactive leaf is client
export default function Page() {      // Server Component
  return <Layout><InteractiveForm /></Layout>
}
// interactive-form.tsx
"use client"
export function InteractiveForm() { ... }
```

## Data Fetching

Fetch data directly in Server Components with `async/await`. No `useEffect`, no SWR, no React Query for server-side data.

```tsx
// Good — fetch in Server Component
export default async function UserProfile({ id }: { id: string }) {
  const user = await db.users.findById(id)  // direct, no API round-trip
  return <Profile user={user} />
}
```

For client-side data (mutations, real-time): use Server Actions or Route Handlers.

## Images

Always use `next/image`. Never `<img>`.

```tsx
import Image from "next/image"
<Image src="/hero.jpg" alt="Hero" width={800} height={400} priority />
```

Add `priority` for above-the-fold images. Define `sizes` for responsive images.

## Fonts

Always use `next/font`. Never load fonts from CDN in `<head>`.

```tsx
import { Inter } from "next/font/google"
const inter = Inter({ subsets: ["latin"] })
export default function Layout({ children }) {
  return <html className={inter.className}>{children}</html>
}
```

## Metadata

Use the Metadata API — never manual `<head>` tags.

```tsx
// app/page.tsx
export const metadata = {
  title: "My App",
  description: "...",
  openGraph: { images: ["/og.png"] }
}
```

## Loading & Streaming

Use `loading.tsx` for route-level loading states. Use `<Suspense>` for component-level.

```tsx
// app/dashboard/loading.tsx  — automatic skeleton
export default function Loading() { return <DashboardSkeleton /> }

// In a Server Component
<Suspense fallback={<ChartSkeleton />}>
  <SlowChart />   {/* streams in when ready */}
</Suspense>
```

## Error Handling

Use `error.tsx` for route-level errors. Must be a Client Component.

```tsx
// app/dashboard/error.tsx
"use client"
export default function Error({ error, reset }: { error: Error, reset: () => void }) {
  return <div><p>{error.message}</p><button onClick={reset}>Retry</button></div>
}
```

## Route Handlers

Only use Route Handlers (`app/api/route.ts`) for:
- Webhooks from external services
- APIs consumed by external clients
- OAuth callbacks

**Do not create Route Handlers for internal data fetching** — fetch directly in Server Components or use Server Actions.

## Supporting Files

- **server-vs-client.md** — Decision tree: when to use Server vs Client Component
- **patterns.md** — Common patterns: Server Actions, parallel data fetching, caching
