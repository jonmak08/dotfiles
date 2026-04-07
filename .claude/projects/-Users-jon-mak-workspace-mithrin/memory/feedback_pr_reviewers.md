---
name: Mithrin PR creation additions
description: Supplements gusto-dev:create-pr skill with Mithrin-specific steps — reviewers, Jira transition, PR template
type: feedback
---

When creating a PR, use the `gusto-dev:create-pr` skill for the core workflow. In addition, always do these Mithrin-specific steps:

1. **Add default reviewers** — `--reviewer jlee1201,dchandc,rjnienaber-gusto,krishna-donepudi,michjun,RyanDimitriRamos,scottland104` on `gh pr create`
2. **Transition the Jira ticket to "In Review"** — TC project: transition ID 121, EPDSUPPORT: transition ID 71
3. **Use the repo PR template** — the `gusto-dev:create-pr` skill checks for this, but if it's missed, the template is at `.github/pull_request_template.md`. Do NOT use a custom format.

**Why:** All three steps were missed on PR #6172 — user had to correct each one. These must be automatic every time a PR is created.

**How to apply:** After `gusto-dev:create-pr` finishes (or if creating a PR manually), verify reviewers are added, the Jira ticket is transitioned, and the PR body follows the repo template.
