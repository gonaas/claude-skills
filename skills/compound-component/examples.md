# Compound Component Examples

## Accordion

```tsx
// accordion.tsx
interface AccordionContext {
  openItem: string | null
  toggle: (id: string) => void
}

const AccordionContext = createContext<AccordionContext | null>(null)

function Accordion({ children }: { children: ReactNode }) {
  const [openItem, setOpenItem] = useState<string | null>(null)
  const toggle = (id: string) => setOpenItem(prev => prev === id ? null : id)
  return <AccordionContext.Provider value={{ openItem, toggle }}>{children}</AccordionContext.Provider>
}

function AccordionItem({ id, title, children }: { id: string; title: string; children: ReactNode }) {
  const { openItem, toggle } = useContext(AccordionContext)!
  const isOpen = openItem === id
  return (
    <div>
      <button onClick={() => toggle(id)}>{title} {isOpen ? "▲" : "▼"}</button>
      {isOpen && <div>{children}</div>}
    </div>
  )
}

Accordion.Item = AccordionItem

// Usage
<Accordion>
  <Accordion.Item id="a" title="Section A">Content A</Accordion.Item>
  <Accordion.Item id="b" title="Section B">Content B</Accordion.Item>
</Accordion>
```

## Tabs

```tsx
interface TabsContext {
  active: string
  setActive: (id: string) => void
}

const TabsContext = createContext<TabsContext | null>(null)

function Tabs({ children, defaultTab }: { children: ReactNode; defaultTab: string }) {
  const [active, setActive] = useState(defaultTab)
  return <TabsContext.Provider value={{ active, setActive }}>{children}</TabsContext.Provider>
}

function TabList({ children }: { children: ReactNode }) {
  return <div role="tablist">{children}</div>
}

function Tab({ id, children }: { id: string; children: ReactNode }) {
  const { active, setActive } = useContext(TabsContext)!
  return (
    <button role="tab" aria-selected={active === id} onClick={() => setActive(id)}>
      {children}
    </button>
  )
}

function TabPanel({ id, children }: { id: string; children: ReactNode }) {
  const { active } = useContext(TabsContext)!
  if (active !== id) return null
  return <div role="tabpanel">{children}</div>
}

Tabs.List = TabList
Tabs.Tab = Tab
Tabs.Panel = TabPanel

// Usage
<Tabs defaultTab="profile">
  <Tabs.List>
    <Tabs.Tab id="profile">Profile</Tabs.Tab>
    <Tabs.Tab id="settings">Settings</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel id="profile"><ProfileForm /></Tabs.Panel>
  <Tabs.Panel id="settings"><SettingsForm /></Tabs.Panel>
</Tabs>
```

## Modal

```tsx
interface ModalContext {
  isOpen: boolean
  close: () => void
}

const ModalContext = createContext<ModalContext | null>(null)

function Modal({ children, isOpen, onClose }: { children: ReactNode; isOpen: boolean; onClose: () => void }) {
  if (!isOpen) return null
  return (
    <ModalContext.Provider value={{ isOpen, close: onClose }}>
      <div className="modal-overlay" onClick={onClose}>
        <div className="modal" onClick={e => e.stopPropagation()}>
          {children}
        </div>
      </div>
    </ModalContext.Provider>
  )
}

function ModalHeader({ children }: { children: ReactNode }) {
  const { close } = useContext(ModalContext)!
  return (
    <div className="modal__header">
      <h2>{children}</h2>
      <button onClick={close} aria-label="Close">✕</button>
    </div>
  )
}

function ModalBody({ children }: { children: ReactNode }) {
  return <div className="modal__body">{children}</div>
}

function ModalFooter({ children }: { children: ReactNode }) {
  return <div className="modal__footer">{children}</div>
}

Modal.Header = ModalHeader
Modal.Body = ModalBody
Modal.Footer = ModalFooter

// Usage
<Modal isOpen={showModal} onClose={() => setShowModal(false)}>
  <Modal.Header>Confirm Delete</Modal.Header>
  <Modal.Body>Are you sure you want to delete this item?</Modal.Body>
  <Modal.Footer>
    <Button variant="ghost" onClick={() => setShowModal(false)}>Cancel</Button>
    <Button variant="destructive" onClick={handleDelete}>Delete</Button>
  </Modal.Footer>
</Modal>
```
