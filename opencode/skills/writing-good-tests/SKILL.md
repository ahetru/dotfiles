---
name: writing-good-tests
description: Guidance for writing high-quality automated tests (unit, integration, or end-to-end) that verify real behavior instead of implementation details, and for spotting/removing low-value or redundant tests. Use this skill whenever the user asks to write tests, review or refactor existing tests, improve test coverage, debug a flaky or brittle test suite, decide what to test vs skip, or asks "is this a good test" / "how do I test X" — in any language or framework (Jest, pytest, JUnit, Go testing, RSpec, etc.). Also trigger when the user is writing new application code and hasn't mentioned tests but the task clearly calls for them (e.g. implementing a function, fixing a bug, building an API endpoint) — proactively suggest and draft tests that cover the behavior just written.
license: MIT
compatibility: opencode
metadata:
  domain: testing
  style: guidelines
---

# Writing Good Tests

## Core philosophy

A test is a claim: "this behavior works, and if it breaks, this test will fail — and if it doesn't break, this test will pass." Every test you write should earn its place by making that claim precisely. Before writing a test, and before keeping one you find in an existing suite, ask:

1. **What behavior does this verify?** If you can't state it as one sentence about observable behavior ("returns 404 when the user doesn't exist"), the test doesn't have a clear purpose yet.
2. **Would this test fail if the behavior broke?** If the answer is no, the test is not actually testing anything — it's decoration.
3. **Would this test fail if the behavior did NOT break?** If yes (a test that fails on refactors, timing, or unrelated changes), it is brittle and will train people to ignore red tests.

If a test can't pass both 2 and 3, rewrite or delete it. A red suite that people learn to ignore is worse than no suite at all.

## Test behavior, not implementation

This is the single most common source of low-value tests. Tests that assert on internals break every time you refactor, even when the behavior didn't change — and refactors that break tests train people to distrust or delete tests.

- **Bad**: asserting a private method was called, checking the exact internal data structure, mocking so heavily that the test just re-states the implementation in different words.
- **Good**: asserting on the return value, the observable side effect (e.g. a row was written, an email-send function was called with the right args), or the public API contract.

Rule of thumb: if you rename a private variable or restructure the function body without changing what it does, the test should not need to change. If it does, you were testing implementation, not behavior.

## What deserves a test

Prioritize in this order:

1. **Business logic and branching** — anything with an `if`, a loop boundary, a calculation, a state transition.
2. **Edge cases and boundaries** — empty input, zero, negative numbers, max/min values, off-by-one boundaries (0, 1, N, N+1), duplicate entries, unicode/special characters in strings.
3. **Error handling** — what happens on invalid input, missing dependencies, timeouts, permission failures. Assert on the actual error type/message/status, not just "it throws something."
4. **Regression tests for real bugs** — when you fix a bug, add a test that would have caught it. This is one of the highest-value tests you can write.
5. **Public contracts / integration points** — the boundary other code or other teams depend on (API responses, exported function signatures, serialization formats).

## What NOT to test (skip or delete these)

- **Trivial code with no logic**: plain getters/setters, simple pass-through wrappers, framework boilerplate. If there's no branch or transformation, there's nothing to verify.
- **The language or framework itself**: don't test that `array.length` works, that a decorator you didn't write behaves as documented, that an ORM saves a row (that's the ORM's test suite's job — but DO test that *your* query/mapping logic is correct).
- **Third-party libraries**: trust their own test suites; test your usage of them at the integration boundary instead, not their internals.
- **Multiple tests asserting the same behavior with trivial input variations** that don't exercise a different code path. Ten tests that all take the same `if` branch are one test with nine expensive duplicates — parametrize instead (see below).
- **Tests that just restate the implementation**: e.g. a test that computes `a + b` in the test itself and asserts it equals what the function returns. This only breaks together with the implementation and can never catch a real bug (both sides are wrong the same way).
- **Snapshot tests of large, opaque blobs** with no human review of what changed — these pass by being blindly re-approved and stop testing anything.

## Structure: Arrange–Act–Assert

Keep tests in three visually separable parts, and keep each test to one logical behavior:

```python
def test_withdraw_fails_when_balance_insufficient():
    # Arrange
    account = Account(balance=50)

    # Act
    result = account.withdraw(100)

    # Assert
    assert result.success is False
    assert account.balance == 50  # unchanged
```

- **One behavior per test.** If a test needs the word "and" to describe what it checks ("...and also verifies logging..."), split it.
- **Name tests after the behavior**, not the method: `test_withdraw_fails_when_balance_insufficient`, not `test_withdraw_2`. A failing test name should tell you what broke without opening the file.
- **Assert on outcomes**, not on the presence of intermediate calls, unless the call itself *is* the contract (e.g. verifying a webhook was sent).

## Isolation and determinism

A test suite people trust is one where a red test always means something is actually broken.

- **No shared mutable state between tests.** Each test should set up its own fixtures and not depend on execution order.
- **No real network calls, real clocks, or real randomness** unless that's specifically what's under test. Inject/mock time and randomness sources; don't `sleep()` to "make timing work" — that produces flaky tests.
- **No dependence on external services** (real databases, real APIs) in unit tests — use fakes, in-memory doubles, or a dedicated integration-test tier that's allowed to be slower and less frequent.
- If a test is flaky (fails intermittently with no code change), that's a bug in the test, not a fact of life — chase it down rather than adding retries.

## Mocking: use the minimum necessary

Over-mocking is a major source of both brittle and low-value tests. Each mock is a claim about how a dependency behaves; if that claim is wrong, the test passes while the real system is broken.

- Mock at architectural boundaries (network, filesystem, time, external services) — not internal collaborators just to isolate a unit for its own sake.
- If a test needs five mocks and complex `when(...).thenReturn(...)` setups just to make one function call reachable, that's a signal the function has too many responsibilities — consider that a design smell, not just a test-writing problem.
- Prefer real objects/fakes over mocks when the real thing is cheap and deterministic (e.g. use a plain in-memory list instead of mocking a repository interface).

## Reduce redundancy: parametrize instead of duplicating

When the same logic needs checking against many inputs, use table-driven / parametrized tests instead of copy-pasted near-identical test functions:

```python
import pytest

@pytest.mark.parametrize("balance,amount,expected", [
    (100, 50, True),    # normal withdrawal
    (100, 100, True),   # exact balance
    (100, 101, False),  # over balance
    (0, 1, False),       # zero balance
    (100, 0, True),      # zero amount, edge case
])
def test_withdraw(balance, amount, expected):
    account = Account(balance=balance)
    assert account.withdraw(amount).success == expected
```

This keeps each case visible, makes it trivial to add a new edge case, and avoids ten near-duplicate function bodies drifting out of sync over time.

## Coverage is a signal, not a goal

100% line coverage doesn't mean the behavior is verified — it only means every line executed at least once. A test that calls a function and asserts nothing, or asserts on something unrelated, still counts toward coverage while checking nothing.

- Use coverage to find *untested* code, not as a target to hit for its own sake.
- Prefer a smaller number of tests that assert meaningfully over a larger number that pad coverage numbers.
- A good sanity check: if you commented out a chunk of the implementation logic, would any test go red? If not, that logic isn't actually covered no matter what the tool reports.

## A pre-commit checklist

Before finalizing a test (or a test suite), check:

- [ ] Each test name describes one specific behavior.
- [ ] Each test would fail if that behavior broke, and would NOT fail for unrelated reasons (refactor, timing, order).
- [ ] Edge cases and error paths are covered, not just the happy path.
- [ ] No test duplicates another test's coverage without exercising a new path — parametrize instead.
- [ ] No test asserts on private/internal implementation details that aren't part of the contract.
- [ ] Mocks are limited to real boundaries (I/O, network, time, randomness), not internal collaborators.
- [ ] Tests are independent — can run in any order or in isolation and still pass.
- [ ] No `sleep()`-based timing hacks; no reliance on real wall-clock time or real random values.
- [ ] Regression tests exist for any bug that was just fixed.

## When reviewing someone else's tests

Apply the same lens: for each test, identify what behavior it claims to verify, then check whether it would actually catch a regression in that behavior. Flag (with the specific reason, referencing the checklist above) any test that:
- Can't fail no matter what the implementation does (dead assertion, always-true condition).
- Tests the same path as another test with no new information.
- Is coupled to internals that could change without changing behavior.
- Relies on real time, real randomness, or execution order to pass reliably.

When suggesting fixes, show the rewritten test rather than only describing the problem in prose.
