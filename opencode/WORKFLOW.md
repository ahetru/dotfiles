# OpenCode Agentic Workflow — Philosophy

## Why this system exists

The goal is to have AI coding agents that are **reusable across projects**
without duplicating rules that belong to roles, tools, or specific codebases.

## Three layers, one direction

Every rule has a home. From the most reusable to the most specific:

| Layer | Lives in | Answers | Changes when |
|-------|----------|---------|--------------|
| **Agent** (role) | `~/.config/opencode/agents/<role>.md` | *How* a backend/frontend/infra/mentor developer thinks and works | You change how you want a role to behave across all projects |
| **Skill** (tool) | `~/.config/opencode/skills/<name>/SKILL.md` | *With what* conventions and patterns a specific technology is used | You learn a new framework or library |
| **Project** (context) | `<repo>/.opencode/AGENTS.md` | *What* we are building, which technologies are in play, what the specific rules are | You switch projects or change the project's stack |

### Principle

A layer **must not** contain information that belongs to the layer above or
below it:

- An agent must never name a specific framework or library (not even "React"
  or "Spring") — the project declares the stack.
- A skill must never describe a specific project's business rules — the
  project owns those.
- A project must never duplicate an agent's role definition — override only
  when truly necessary.

## How agents load their tools

At session start, every agent loads the base skills declared by the global
config (`development-workflow`, `git-workflow`, `writing-good-tests`) plus
the domain skill(s) declared by the project's `AGENTS.md` for that role.

Example: the `backend` agent loads `java-springboot` because innerchess's
`AGENTS.md` says `Backend → java-springboot`. The agent itself never states
which domain skill — the project does.

## Project AGENTS.md: the glue

A project's `AGENTS.md` serves three purposes:

1. **Declare the stack** — which technologies are used (so agents know which
   skills to load)
2. **Describe the project** — what the app does, what it does NOT do, what
   constraints exist
3. **Add project-specific rules** — design system, naming conventions, local
   overrides to skill defaults

### Skills table (required)

Every project `AGENTS.md` must include a table declaring which domain skills
each agent role should load:

```markdown
## Skills

| Role | Domain skill |
|------|-------------|
| Backend | `java-springboot` |
| Frontend | `react-frontend` |
| Infra | (none) |
```

### Overriding a skill

When a project's choices conflict with a skill's recommendations, the project
wins. Make the override explicit:

```markdown
The project's explicit rules (no TanStack Query, no Tailwind) override any
conflicting guidance from the `react-frontend` skill.
```

## File-based ticketing (optional)

Some projects use a file-based ticket system for cross-agent coordination
(e.g. innerchess via `~/projects/agents/innerchess/tickets/`). This is
entirely project-defined — the global config only provides the conventions
for how tickets are handled in the `git-workflow` skill.

## What goes where — cheat sheet

| Content | Agent | Skill | Project |
|---------|:-----:|:-----:|:-------:|
| "RESTful APIs with proper HTTP codes" | ✓ | | |
| "Use @ControllerAdvice for errors" | | ✓ | |
| "Backend: Java, Spring Boot" | | | ✓ |
| "chess.js is UX-only, never authoritative" | | | ✓ |
| "One component = one file" | ✓ | | |
| "TanStack Query for server state" | | | ✓ |
| "Never commit without asking" | ✓ | | |
| "Package-by-feature, not by layer" | ✓ | | |
| "Vitest + React Testing Library" | | | ✓ |
