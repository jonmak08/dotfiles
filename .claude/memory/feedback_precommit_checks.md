---
name: Run all checks before committing
description: Always run linting, type checks, and tests before any git commit — never commit without passing checks
type: feedback
---

Before committing any changes, run ALL relevant checks for the project and ensure they pass. Never commit with failing checks.

Determine the correct commands from the project's CLAUDE.md or standard config files. Common checks include:
- Linting (RuboCop, ESLint, Prettier, etc.)
- Type checking (TypeScript, Sorbet, etc.)
- Tests for changed files (RSpec, Jest, etc.)
- Security scans (Brakeman, etc.) if available

**Why:** User wants to catch issues before they're committed, not after. Failing CI after push wastes time.

**How to apply:** Before every `git commit`, run the project's linting, type checking, and relevant tests. Only commit if all pass. If something fails, fix it first. Only run checks on files/areas affected by the changes — don't run the full test suite unless the changes are broad.
