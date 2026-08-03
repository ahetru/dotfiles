---
name: react-frontend
description: React frontend architecture guidelines — feature-based structure, chess.js + react-chessboard UX-only role split, TanStack Query + Zustand state, and licensing rules (MIT/BSD only, no GPL)
license: MIT
compatibility: opencode
metadata:
  domain: react-frontend
  style: guidelines
---

# React Frontend Architecture Guidelines

## Context

- This skill is project-agnostic: it applies to any chess training app with a
  Spring Boot (or equivalent) backend and a React + Vite + TypeScript
  frontend.
- The **backend engine is the authoritative source of truth** for move
  validation and exercise/puzzle checking.
- The frontend's chess library (chess.js) is a local UX helper only.
- Exercises/puzzles are served by the backend API (e.g. fetched from a CSV or
  a database) and exposed via feature controllers returning DTOs.
- Long-term intent: these apps may become **commercial products**, so all
  frontend dependencies must use permissive licenses (MIT, BSD, ISC) — no
  GPL/AGPL.

## Stack

| Concern | Choice | License | Notes |
|---|---|---|---|
| Framework | React + Vite + TS | — | already in place |
| Routing | React Router | MIT | home, trainer, history/stats screens |
| Server state | TanStack Query | MIT | fetching/caching exercises, submitting attempts |
| Client state | Zustand | MIT | current position, move history, exercise status |
| Chess rules engine (client-side only) | chess.js | BSD-2-Clause | UX-only, never authoritative |
| Board rendering | react-chessboard (v5) | MIT | avoid `chessground` (GPL-3.0) |
| Styling | Tailwind CSS | MIT | |
| UI primitives | shadcn/ui (optional) | MIT | |
| API validation | Zod | MIT | validate/parse backend DTOs |
| Testing | Vitest + React Testing Library | MIT | native to Vite |

## Role split: chess.js vs backend engine

- **Backend engine** = single source of truth. It decides whether a submitted
  move actually solves the exercise.
- **chess.js (frontend)** = local UX helper only, never authoritative:
  - filters legal squares for drag/drop and highlighting
  - detects pawn promotion locally to trigger the promotion dialog
  - parses FEN received from backend to init the board
  - generates SAN notation for move-history display
  - local check/checkmate/stalemate detection for visual cues
- Any divergence between the two engines has no security/business impact —
  worst case the frontend visually allows a move that the backend then rejects.

## Board rendering choice

- Use `chess.js` + `react-chessboard` (both MIT/BSD, commercial-safe).
- **Do not use `chessground`** (Lichess's board lib) — GPL-3.0, would force
  releasing the frontend source if distributed or sold.
- Note: react-chessboard's default piece SVGs are CC BY-SA 3.0
  (Wikimedia/Cburnett) — usable commercially but requires attribution/
  share-alike; consider a custom or differently-licensed piece set later if
  that's a concern.

## Folder structure (feature-based, mirrors the backend domain split)

```
src/
├── app/
│   ├── App.tsx
│   ├── router.tsx
│   └── providers.tsx          # QueryClientProvider, etc.
├── features/
│   └── <feature>/             # e.g. exercise, trainer, history
│       ├── api/
│       │   └── <feature>.api.ts
│       ├── components/
│       │   ├── ExerciseBoard.tsx
│       │   ├── ExerciseControls.tsx
│       │   └── ExerciseFeedback.tsx
│       ├── hooks/
│       │   ├── useExercise.ts       # TanStack Query: fetch an exercise
│       │   └── useExerciseGame.ts   # chess.js + zustand game logic
│       ├── store/
│       │   └── exerciseStore.ts     # position, move history, status
│       └── types/
│           └── exercise.types.ts
├── components/
│   ├── ui/                    # shared dumb UI primitives (buttons, modals)
│   └── layout/
│       ├── Header.tsx
│       └── Layout.tsx
├── lib/
│   ├── api/
│   │   └── client.ts           # base fetch/axios config
│   └── chess/
│       └── chessEngine.ts      # thin wrapper around chess.js if needed
├── styles/
│   └── index.css
└── main.tsx
```

Replace `<feature>` and `Exercise*` with the actual domain name (e.g. puzzle,
trainer, drill).

## Design principles

1. **Group by feature/domain, not by file type** — mirrors the backend's
   package structure.
2. **Keep `components/` and `lib/` strictly for cross-feature shared code**;
   feature-specific code stays inside its `features/<name>/` folder.
3. **Never implement move-legality or exercise-correctness logic in the
   frontend as the final authority** — always defer to the backend API for
   validation.
4. **All new dependencies must be checked for license compatibility**
   (MIT/BSD/ISC preferred, avoid GPL/AGPL) before being added, given the
   commercial intent.

## API access

- API calls only through `api/` modules (per-feature under
  `features/<name>/api/`, or a shared `api/` folder) using the shared client.
- No raw HTTP calls in components or stores.
- Parse and validate backend DTOs with Zod at the API boundary.

## Testing

- Use Vitest + React Testing Library.
- Prefer testing hooks and store logic independently of rendering where
  possible; keep business logic decoupled from components.
