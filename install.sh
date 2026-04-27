#!/usr/bin/env bash
set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"

strip_frontmatter() {
  awk 'BEGIN{f=0} /^---/{f++; next} f!=1{print}' "$1"
}

install_claude_code() {
  mkdir -p ~/.claude/skills
  cp -r "$SKILLS_DIR"/. ~/.claude/skills/
  echo "✓ Claude Code  →  ~/.claude/skills/"
}

install_opencode() {
  mkdir -p ~/.config/opencode/agents
  for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    output="$HOME/.config/opencode/agents/${skill_name}.md"
    > "$output"
    for md in "$skill_dir"*.md; do
      [ -f "$md" ] || continue
      strip_frontmatter "$md" >> "$output"
      echo "" >> "$output"
    done
  done
  echo "✓ OpenCode     →  ~/.config/opencode/agents/"
}

install_codex() {
  mkdir -p ~/.codex
  output="$HOME/.codex/AGENTS.md"
  > "$output"
  for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    echo "# $skill_name" >> "$output"
    echo "" >> "$output"
    for md in "$skill_dir"*.md; do
      [ -f "$md" ] || continue
      strip_frontmatter "$md" >> "$output"
      echo "" >> "$output"
    done
  done
  echo "✓ Codex        →  ~/.codex/AGENTS.md"
}

if [ $# -eq 0 ]; then
  detected=0
  command -v claude &>/dev/null   && install_claude_code && detected=1
  [ -d ~/.config/opencode ]       && install_opencode    && detected=1
  command -v codex &>/dev/null    && install_codex       && detected=1
  [ -d ~/.codex ] && ! command -v codex &>/dev/null && install_codex && detected=1
  [ $detected -eq 0 ] && echo "No AI coding tool detected. Use a flag: --claude | --opencode | --codex | --all"
else
  for arg in "$@"; do
    case $arg in
      --claude)   install_claude_code ;;
      --opencode) install_opencode ;;
      --codex)    install_codex ;;
      --all)      install_claude_code; install_opencode; install_codex ;;
      *) echo "Unknown flag: $arg. Valid flags: --claude --opencode --codex --all" ;;
    esac
  done
fi
