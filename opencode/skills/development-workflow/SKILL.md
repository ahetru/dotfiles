---
name: development-workflow
description: How to execute code changes — plan first, break work into small steps, commit regularly with small focused commits
license: MIT
compatibility: opencode
metadata:
  domain: workflow
  style: guidelines
---

# Development Workflow

## Agent responsibilities

- **Never commit without explicit user authorization.** Propose the commit
  message and wait for confirmation before running `git commit`.
- **Never run `git push`.** The user pushes themselves.

## Language

- All written artifacts — documentation, skills, tickets, task lists, commit
  messages, code comments — are written in **English**.
- The user's language (e.g. French) is only used for chat conversation, never
  for artifacts.

## Working style

Prioritize small, planned, well-organized changes over big one-shot rewrites.
A large change delivered in one go is a failure of process, not a fast win.

### Plan before coding

- Understand the current code first.
- Propose a plan and break the work into small, logical steps.
- For anything non-trivial, agree on the plan before implementing.

### Small steps

- Implement one logical step at a time.
- Keep each step testable and self-contained.
- Do not mix unrelated concerns in the same step.

### Regular commits

- Commit often, one small focused commit per step.
- Follow the `git-workflow` skill for the commit message format
  (`type(scope): subject`).
- Avoid giant commits mixing unrelated changes.
- Each commit is proposed to the user and committed only after authorization.

### Verify

- Run the relevant tests/lint after each step, not only at the end.
- Only consider a step done when its checks pass.

## Dependency management

- **Add a dependency only when it becomes necessary** for the task at hand,
  not preemptively because a roadmap or a skill mentions it.
- Multiplying dependencies is not inherently a good thing: each one adds
  surface area, upgrade burden, license review and potential supply-chain
  risk. A lean dependency set is a feature.
- Before adding a dependency, ask: *is the current tooling enough?* Many
  needs (fetching, small state, routing for a few screens) are covered by
  plain React/TS without a library.
- When a dependency is added, note the phase/task it was needed for and verify
  its license compatibility (see `react-frontend` skill, MIT/BSD/ISC only).

## Cross-agent ticketing

Process (when the project uses a file-based ticket system — check the project's
local `.opencode/AGENTS.md` for the ticket directory path):

- At the start of a session, check the tickets assigned to you (frontmatter
  `to: <your role>`) and take them up before starting new tasks.
- When a blocker belongs to another agent's domain, open a ticket (follow the
  template in `tickets/README.md`) instead of hacking around it.
- Every time you work on a ticket, append a timestamped entry to its
  `## Activity` section and bump the `updated` frontmatter field.
- Reference tickets in commits by their filename (e.g.
  `closes ticket 2026-08-01-1730-<slug>`).
- Never resolve a ticket without the user's confirmation.

## Related skills

- Load `git-workflow` for anything related to committing, branching or pull
  requests.
- Load `understand-the-code` to track concepts the user struggles with during
  the session.
