# Global rules (all projects)

## Hard rules

- **Never run `git commit`, `git push`, or any force/history-rewriting git
  command (`push --force`, `rebase`, `reset --hard`, `filter-branch`, etc.)
  without explicit user authorization.** Always ask first, even for small or
  "obviously safe" changes. The agent proposes the commit message and waits
  for confirmation before committing. The user performs pushes themselves.
- **Never run destructive filesystem operations** (`rm -rf`, bulk deletes,
  overwriting files outside the current working tree) without explicit
  confirmation, and never touch files outside the project directory.
- **Never read, print, log, or transmit secrets** (`.env` files, API keys,
  tokens, credentials, private keys). If a task requires a secret, ask the
  user to provide it via an environment variable or secret manager — never
  hardcode it into a file or commit.
- **Never install or run unverified scripts/binaries** (e.g. curl-pipe-to-
  shell installers) without telling the user what they do and asking first.
- If any of the above is ambiguous, **stop and ask** rather than guessing.

## Language

All written artifacts (docs, skills, tickets, commits, code comments) are in
**English**. Chat with the user may use their language.

## Separation of concerns

The configuration follows three layers, from reusable to specific:

| Layer | Location | Contains |
|-------|----------|----------|
| **Agents** (role) | `~/.config/opencode/agents/` | Role definition and universal principles. Technology-agnostic — no framework or library names. |
| **Skills** (tools) | `~/.config/opencode/skills/` | Technology-specific guidelines and conventions (e.g. `java-springboot`, `react-frontend`). |
| **Project** | `<repo>/.opencode/AGENTS.md` | Tech stack declaration, project context, and local rules. Declares which domain skills each role must load. |

When editing `agents/*.md`, periodically check that no technology-specific
convention has leaked in — those belong in `skills/`.

## Skills

Universal skills are loaded automatically for every session via the
`instructions` field in `~/.config/opencode/opencode.json` — this guarantees
they're actually read, rather than relying on the agent remembering a prose
instruction:

```json
{
  "instructions": [
    "skills/development-workflow/SKILL.md",
    "skills/git-workflow/SKILL.md"
  ]
}
```

In addition, at the start of a session, coding agents (backend, frontend,
infra) **must** load:

1. `writing-good-tests`
2. The domain skill declared by the project for their role — check the
   project's `AGENTS.md` for the stack.

**Fallback:** if a project declares a domain skill that doesn't exist
locally, or has no `.opencode/AGENTS.md` at all, the agent must stop and ask
the user which stack/skill applies rather than assuming one.

## Project-specific context

Each project provides its own instructions via a local `.opencode/AGENTS.md`
file. Project-specific context (workspace paths, tech stack, design system,
task coordination, etc.) belongs in the project, not in global configuration.

Do **not** duplicate agent files (`agents/<role>.md`) at the project level
unless the project truly needs a different agent definition. Use
`AGENTS.md` for project-specific context and rules instead.

Coding agents must check the project's local `AGENTS.md` for any workspace
layout, task folders, or ticket systems before starting work. If it's
missing, ask the user rather than inferring the project structure from the
file tree.
