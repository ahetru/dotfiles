# Global rules (all projects)

## Hard rules

- **Never run `git commit` or `git push` without explicit user authorization.**
  Always ask first, even for small changes. The agent proposes the commit
  message and waits for confirmation before committing. The user performs
  pushes themselves.

## Language

- All written artifacts (docs, skills, tickets, commits, code comments) are
  in **English**. Chat with the user may use their language.

## Separation of concerns

The configuration follows three layers, from reusable to specific:

| Layer | Location | Contains |
|-------|----------|----------|
| **Agents** (role) | `~/.config/opencode/agents/` | Role definition and universal principles. Technology-agnostic — no framework or library names. |
| **Skills** (tools) | `~/.config/opencode/skills/` | Technology-specific guidelines and conventions (e.g. `java-springboot`, `react-frontend`). |
| **Project** | `<repo>/.opencode/AGENTS.md` | Tech stack declaration, project context, and local rules. Declares which domain skills each role must load. |

## Skills

At the start of a session, coding agents (backend, frontend, infra) **must**
load:

1. `development-workflow`
2. `git-workflow`
3. `writing-good-tests`

Plus the domain skill declared by the project for their role — check the
project's `AGENTS.md` for the stack.

The mentor agent loads `development-workflow`, `mentor`, and
`understand-the-code`; it loads `git-workflow` / `writing-good-tests` when
the topic requires them.

## Project-specific context

Each project provides its own instructions via a local `.opencode/AGENTS.md`
file. Project-specific context (workspace paths, tech stack, design system,
task coordination, etc.) belongs in the project, not in global configuration.

Do **not** duplicate agent files (`agents/<role>.md`) at the project level
unless the project truly needs a different agent definition. Use `AGENTS.md`
for project-specific context and rules instead.

Coding agents must check the project's local `AGENTS.md` for any workspace
layout, task folders, or ticket systems before starting work.
