# Global rules (all projects)

## Hard rules

- **Never run `git commit` or `git push` without explicit user authorization.**
  Always ask first, even for small changes. The agent proposes the commit
  message and waits for confirmation before committing. The user performs
  pushes themselves.

## Skills

At the start of a session, load the `development-workflow` skill. Load the
`git-workflow` skill whenever the task involves git operations (committing,
branching, pull requests).
