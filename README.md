# claude-skills

Personal Claude Code skills for consistent development workflows across all projects.

## Skills

| Skill | Type | Description |
|---|---|---|
| [`tdd`](skills/tdd/) | Agnostic | Test-Driven Development. Iron Law: no production code without a failing test first. |
| [`systematic-debugging`](skills/systematic-debugging/) | Agnostic | Systematic debugging. Iron Law: NO FIXES WITHOUT REPRODUCTION FIRST. |
| [`shaping`](skills/shaping/) | Agnostic | Shape Up: design before implementation. NO IMPLEMENTATION BEFORE ALIGNMENT. |
| [`react-best-practices`](skills/react-best-practices/) | React/Next.js | Vercel best practices: Server Components, data fetching, images, fonts, metadata. |
| [`compound-component`](skills/compound-component/) | React | Compound Component pattern: Context + dot notation for composable UI. |

## Installation

Copy any skill folder to your `~/.claude/skills/` directory:

```bash
# Clone the repo
git clone https://github.com/astudillogonzalo/claude-skills.git

# Install all skills
cp -r claude-skills/skills/* ~/.claude/skills/

# Or install a single skill
cp -r claude-skills/skills/tdd ~/.claude/skills/
```

## Usage

Skills are triggered automatically when relevant, or you can invoke them directly:

```
/tdd
/systematic-debugging
/shaping
/react-best-practices
/compound-component
```

## Credits

- `tdd`, `systematic-debugging`, `shaping` — adapted from [somebody32/agents](https://github.com/somebody32/agents)
- `react-best-practices` — based on [Vercel/Next.js documentation](https://nextjs.org/docs)
- `compound-component` — original
