# React / Next.js Patterns

## Server Actions

Use Server Actions for mutations — not Route Handlers.

```tsx
// actions.ts
"use server"
export async function createUser(formData: FormData) {
  const name = formData.get("name") as string
  await db.users.create({ name })
  revalidatePath("/users")
}

// form.tsx (Server Component — no "use client" needed for form submission)
import { createUser } from "./actions"
export function CreateUserForm() {
  return (
    <form action={createUser}>
      <input name="name" />
      <button type="submit">Create</button>
    </form>
  )
}
```

## Parallel Data Fetching

Avoid sequential awaits — fetch in parallel with `Promise.all`:

```tsx
// Bad — sequential: user fetches THEN posts fetch (waterfall)
const user = await getUser(id)
const posts = await getPosts(id)

// Good — parallel
const [user, posts] = await Promise.all([getUser(id), getPosts(id)])
```

## Caching & Revalidation

```tsx
// Cache for 1 hour
const data = await fetch(url, { next: { revalidate: 3600 } })

// No cache (always fresh)
const data = await fetch(url, { cache: "no-store" })

// Tag-based revalidation
const data = await fetch(url, { next: { tags: ["products"] } })
// Then in a Server Action:
revalidateTag("products")
```

## Optimistic Updates

```tsx
"use client"
import { useOptimistic } from "react"

export function TodoList({ todos, addTodo }) {
  const [optimisticTodos, addOptimistic] = useOptimistic(
    todos,
    (state, newTodo) => [...state, { ...newTodo, pending: true }]
  )

  async function formAction(formData: FormData) {
    const todo = { text: formData.get("text") as string }
    addOptimistic(todo)
    await addTodo(todo)
  }

  return (
    <form action={formAction}>
      {optimisticTodos.map(t => <li key={t.id} style={{ opacity: t.pending ? 0.5 : 1 }}>{t.text}</li>)}
      <input name="text" />
    </form>
  )
}
```

## Dynamic Routes with generateStaticParams

```tsx
// app/blog/[slug]/page.tsx
export async function generateStaticParams() {
  const posts = await db.posts.findAll()
  return posts.map(post => ({ slug: post.slug }))
}
```

## Environment Variables

- `NEXT_PUBLIC_*` → available on client (exposed in JS bundle — never put secrets here)
- Everything else → server only

```ts
// Server Component / Route Handler / Server Action — safe
const apiKey = process.env.STRIPE_SECRET_KEY

// Client Component — only NEXT_PUBLIC_ vars
const publicKey = process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY
```
