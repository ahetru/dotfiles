---
name: understand-the-code
description: Identify concepts the user seems not to understand during coding sessions and document them in the understand-the-code directory with examples and documentation links
license: MIT
compatibility: opencode
metadata:
  domain: learning
  style: guidelines
---

# Understand The Code

The user is a beginner in Java/Spring Boot and web development. During coding
sessions, watch for signs that a concept is not fully understood and write it
down in the `understand-the-code` directory. The goal is to surface
improvement areas over time, not to fix everything at once.

## When to take notes

Record a learning gap when you notice any of these signs:

- The user asks a question about something that was already explained.
- The user's question or assumption reveals a wrong mental model.
- The user asks for the same explanation again, rephrased.
- The user appears confused by a step, even if they do not say it.
- The user accepts an explanation but later misapplies it.
- A concept the user is new to plays a central role in the current task
  (e.g. first time with `@WebMvcTest`, `@ConfigurationProperties`, Java
  records, HTTP status codes, etc.).

Be selective: note genuine gaps, not every small question. Prefer a few
high-value items over exhaustive lists.

## Where to write

```
/home/ahetru/projects/understand-the-code/<project-name>/
```

- `project-name` is the current working directory name (e.g. `my-project`).
- Create the directory if it does not exist.
- One file per session, named `YYYY-MM-DD_HH-MM_learning-gaps.txt`.

## Note structure

For each gap, write:

1. **Topic** — the concept (e.g. "Spring `@WebMvcTest` slices").
2. **What I got wrong / was unsure about** — the exact misunderstanding
   observed, in the user's own framing when possible.
3. **Why it works that way** — a short, correct explanation.
4. **Example** — a concrete snippet from the current code, or a minimal
   illustrative example.
5. **To go further** — documentation links (Spring reference, Baeldung,
   MDN...). Only link authoritative, relevant pages.

End the file with a short **Improvement axes** section: the 2-3 recurring
themes worth studying next (e.g. "Spring Boot test slices", "records vs
entities").

## Style

- French explanations preferred, matching the user's language.
- Concise, concrete, no fluff.
- Link to docs the user can read on their own.
