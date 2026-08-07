---
name: react-frontend
description: React frontend architecture guidelines — feature-based structure, state management, component design, API access, and testing best practices
license: MIT
compatibility: opencode
metadata:
  domain: react-frontend
  style: guidelines
---

# React Frontend Architecture Guidelines

## Philosophy

- Components are dumb, hooks are smart — business logic lives in hooks, not in
  JSX
- Group by feature/domain, not by file type
- State has a shape: server state (fetched, cached) ≠ client state (ephemeral,
  local)
- The project's AGENTS.md is authoritative for library choices; this skill
  provides patterns and conventions

## Folder structure (feature-based)

```
src/
├── app/
│   ├── App.tsx
│   ├── router.tsx
│   └── providers.tsx
├── features/
│   └── <feature>/
│       ├── api/
│       │   └── <feature>.api.ts
│       ├── components/
│       ├── hooks/
│       ├── store/          (optional, if feature has local state)
│       └── types/
├── components/
│   ├── ui/                 (shared presentational primitives)
│   └── layout/
├── lib/                    (cross-cutting utilities, API client, etc.)
├── styles/
└── main.tsx
```

Rules:

- Feature code stays inside its `features/<name>/` folder — never leak into
  `components/` or `lib/`
- `components/` and `lib/` are for **shared** code only
- API calls only through dedicated api modules, no raw HTTP in components or
  stores

## Components

- Functional components with hooks — no class components
- One component = one file, private sub-components can stay in the same file
- Props typed with `interface`, exported if the component is public
- No business logic inside components — extract to hooks

## State management

Two categories of state:

| Category | Purpose | Example |
|----------|---------|---------|
| **Server state** | Data owned by the backend | fetched exercises, user profile |
| **Client state** | Ephemeral UI-only state | current position, dark mode, form drafts |

- Server state should be managed by a data-fetching library with caching and
  invalidation (e.g. TanStack Query, SWR)
- Client state should be managed by a lightweight store (e.g. Zustand, Jotai)
  or React context
- Never mix server state into a client-state store

## API access

- Centralize API configuration (base URL, headers, auth) in a shared client
- Each feature has its own API module that uses the shared client
- Validate responses at the API boundary (e.g. Zod) so the rest of the app
  trusts the shape
- No raw HTTP calls in components, stores, or hooks outside the API layer

## Styling

- Consistent approach across the project — one system (CSS modules, Tailwind,
  token-based CSS, etc.)
- Token-based theming (dark/light) via CSS variables or utility classes
- Respect `prefers-reduced-motion` — disable animations when the user requests it
- Accessibility: semantic HTML, ARIA roles, keyboard navigation, AA color
  contrast minimum

## TypeScript

- Strict mode — no `any` except justified exceptions
- Prefer `interface` for public types, `type` for unions and utilities
- Derive types from data shapes when possible (e.g. Zod inference from backend
  DTOs)

## Testing

- Vitest + React Testing Library (or equivalent)
- Test behavior, not implementation — what the user sees and does
- Prefer testing hooks and business logic independently of rendering
- No snapshot tests, no style-only tests
