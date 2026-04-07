---
name: Always use 5-round code quality checklist
description: Every code interaction (writing, reviewing, suggesting changes) must pass the 5-round checklist — not just PR reviews
type: feedback
---

Always apply the 5-round checklist whenever interacting with code — writing new code, suggesting changes, reviewing PRs, fixing bugs, or refactoring.

1. **Structural Review** — Architecture, design, data flow, security risks
2. **Functional & Logic Review** — Does it work? Edge cases? Test coverage?
3. **Security & Compliance** — OWASP top 10, secret leaks, SQL injection, authorization, PII masking
4. **Performance & Maintainability** — Memory leaks, inefficient queries, readability
5. **Final Verification** — All feedback addressed, code clean, ready to commit/merge

**Why:** User wants consistent quality across all code interactions, not just formal PR reviews. Ad-hoc work that skips these dimensions leads to issues caught later in review or production.

**How to apply:** For PR reviews, present each round as a labeled section with Pass/Concern status and a summary table. For writing/suggesting code changes, use the checklist internally to validate your work before presenting it — you don't need to show all 5 rounds for every small change, but do flag any concerns found.
