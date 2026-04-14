# Server vs Client Component — Decision Tree

## Quick Decision

```
Does the component need any of these?
  ├── useState / useReducer / useEffect          → "use client"
  ├── Browser APIs (window, document, navigator) → "use client"
  ├── Event handlers (onClick, onChange, etc.)   → "use client"
  ├── Third-party client-only library            → "use client"
  └── None of the above                          → Server Component ✅
```

## Capability Comparison

| Capability | Server Component | Client Component |
|---|---|---|
| Fetch data (DB, API) | ✅ Direct | ⚠️ Via API only |
| Access server env vars | ✅ | ❌ |
| useState / useEffect | ❌ | ✅ |
| onClick / onChange | ❌ | ✅ |
| Browser APIs | ❌ | ✅ |
| Reduce JS bundle | ✅ Zero JS | ❌ Adds JS |
| Can import Server Components | ✅ | ❌ |
| Can use Server Actions | ✅ | ✅ (via form/function) |

## Common Patterns

### Pattern 1: Server parent, Client leaf
```tsx
// page.tsx — Server Component
export default async function Page() {
  const data = await fetchData()
  return (
    <div>
      <StaticContent data={data} />     {/* Server */}
      <InteractiveWidget />              {/* Client */}
    </div>
  )
}
```

### Pattern 2: Pass Server data to Client via props
```tsx
// Server Component fetches, Client Component renders interactively
export default async function ProductPage({ id }) {
  const product = await db.products.find(id)   // Server
  return <ProductEditor product={product} />    // Client
}
```

### Pattern 3: Children pattern (Server inside Client)
```tsx
// layout.tsx (Server)
export default function Layout({ children }) {
  return <ClientWrapper>{children}</ClientWrapper>  // children = Server Components
}
// client-wrapper.tsx
"use client"
export function ClientWrapper({ children }) {
  const [open, setOpen] = useState(false)
  return <div onClick={() => setOpen(true)}>{children}</div>
  // children are Server Components — they are NOT re-rendered on client
}
```

## What NOT to do

```tsx
// Bad — unnecessary "use client" on a page with no interactivity
"use client"
export default async function AboutPage() {
  const content = await fetchContent()
  return <article>{content}</article>
}

// Bad — fetching in useEffect when a Server Component would work
"use client"
export default function UserList() {
  const [users, setUsers] = useState([])
  useEffect(() => { fetch("/api/users").then(...) }, [])  // unnecessary round-trip
}
```
