# claude-skills

Agent skills for consistent development workflows. Works with Claude Code, OpenCode, and Codex CLI.

## Skills

| Skill | Description |
|---|---|
| [`tdd`](skills/tdd/) | Test-Driven Development. Iron Law: no production code without a failing test first. |
| [`systematic-debugging`](skills/systematic-debugging/) | Systematic debugging. Iron Law: NO FIXES WITHOUT REPRODUCTION FIRST. |
| [`shaping`](skills/shaping/) | Shape Up: design before implementation. NO IMPLEMENTATION BEFORE ALIGNMENT. |
| [`design-an-interface`](skills/design-an-interface/) | Design It Twice: parallel sub-agents explore radically different API designs before committing. |
| [`react-best-practices`](skills/react-best-practices/) | Vercel best practices: Server Components, data fetching, images, fonts, metadata. |
| [`compound-component`](skills/compound-component/) | Compound Component pattern: Context + dot notation for composable UI. |

## Installation

### One-liner (auto-detects your tools)

```bash
git clone https://github.com/gonaas/claude-skills.git && cd claude-skills && ./install.sh
```

Or without cloning:

```bash
curl -fsSL https://raw.githubusercontent.com/gonaas/claude-skills/main/install.sh | bash -s -- --all
```

### Install for a specific tool

```bash
./install.sh --claude    # Claude Code  →  ~/.claude/skills/
./install.sh --opencode  # OpenCode     →  ~/.config/opencode/agents/
./install.sh --codex     # Codex CLI    →  ~/.codex/AGENTS.md
./install.sh --all       # All three
```

### Manual installation

**Claude Code**
```bash
cp -r skills/* ~/.claude/skills/
```

**OpenCode** — each skill becomes a separate agent file (frontmatter stripped automatically by the script):
```bash
mkdir -p ~/.config/opencode/agents
# copy skills/*.md → ~/.config/opencode/agents/
```

**Codex CLI**
```bash
cat skills/*/SKILL.md > ~/.codex/AGENTS.md
```

## Commands

Slash commands for explicit, action-oriented tasks (Claude Code only):

| Command | Description |
|---|---|
| [`/generate-tests [file-path]`](commands/testing/generate-tests.md) | Full test suite for an existing file |
| [`/generate-tests --tdd [name]`](commands/testing/generate-tests.md) | ONE minimal failing test before implementation (RED step) |

Install commands:
```bash
cp -r commands/* ~/.claude/commands/
```

## Usage

Skills trigger automatically when relevant, or invoke them directly:

```
/tdd
/systematic-debugging
/shaping
/design-an-interface
/react-best-practices
/compound-component
```
