# PR and Review Workflow

## Default PR Reviewers
Always add these reviewers when creating PRs:
- jlee1201 (John Lee)
- dchandc (Dennis Chan)
- rjnienaber-gusto (Richard Nienaber)
- krishna-donepudi (Krishna Donepudi)
- michjun (Michelle Fang)
- RyanDimitriRamos (Dimitri Ramos)
- scottland104 (Scott Lee)

## Approval Comment
- If the PR had reviewer comments and all are addressed: `LGTM.  Thanks! All comments are addressed`
- If the PR had no reviewer comments: `LGTM. Thanks!`
- For notable PRs, add context after (e.g., related tickets, backfill questions).

## PR Description
Always use the PR template at `.github/pull_request_template.md` for the PR body. Do not use a custom format.
**Keep PR description in sync with code changes.** After addressing review comments that change the implementation (e.g., swapping feature flags, renaming things), update the PR description to match. Future readers rely on the description being accurate.

## Resolving Review Comments
Use the `/resolve-review-comments` skill (~/.claude/skills/resolve-review-comments/).

## Branch Naming
Use just the Jira ticket ID: `TC-1234` — no username prefix, no description suffix.

## Commit Message Format
```
type(TICKET-ID): Short description
```
- Separate feature changes and refactors into distinct commits
- When addressing review comments, each comment fix should be its own separate git commit for clarity
- When addressing review comments, reference the commit SHA in the reply
- For CI fix commits, mention the tool that failed in the description (e.g., rubocop, eslint, sorbet, vitest, rspec, etc.)

## Common Review Feedback Patterns
Based on 6 months of PR reviews, these are the most frequent issues raised:

### 1. Missing Test Coverage (most common)
- New components/hooks need tests — reviewers will request them
- Cover edge cases: nil inputs, empty states, error scenarios
- Test all branches (e.g., if checking 3 statuses, test all 3)
- Regression tests for bug fixes (test the exact scenario that broke)

### 2. Nil/Null Safety
- Reviewers frequently catch unguarded nil access
- Check for nil before property chains
- Use nil-safe patterns (`&.method`, `|| ''`, `!= 'Yes'` over `== 'No'`)

### 3. Safe Removals / Backward Compatibility
- Don't remove backend fields until frontend is deployed
- Keep dual-writes during migrations
- Don't delete handlers for older API versions still in use
- When flagged as "Important" by reviewers, defer removals

### 4. Code Duplication
- Flag duplicated code in reviews, create follow-up tickets (e.g., TC-6007)
- Extract shared helpers when pattern appears in 2+ places

### 5. GraphQL / Apollo
- Check `success` field before cache updates
- Add `onError` handlers to queries
- Use generated TypeScript types on `useQuery<Type>()`

### 6. Loading State Races
- Multiple independent queries can resolve at different times
- Ensure UI doesn't flash incorrect state between query resolutions

## Inline Review Comments
When reviewing PRs, add comments to the specific lines of code rather than one large review body comment. Use inline/line-level comments so authors can see feedback in context.

## 5-Round Code Review Checklist
**MANDATORY for every PR review.** Always use this structured approach — do not skip rounds or do ad-hoc reviews.

1. **Structural Review** — Architecture, design, data flow, security risks
2. **Functional & Logic Review** — Does it work? Edge cases? Test coverage?
3. **Security & Compliance** — OWASP top 10, secret leaks, SQL injection, authorization, PII masking
4. **Performance & Maintainability** — Memory leaks, inefficient queries, readability
5. **Final Verification** — All feedback addressed, PR clean, ready to merge

Present each round as a labeled section with a Pass/Concern status, and end with a summary table.

## Auto-Generated Files
Run these commands and commit the results:

| Trigger | Command | Generated file(s) |
|---|---|---|
| DB column/migration change | `bin/rails db:migrate` | `db/structure.sql` |
| DB column on a model | `yarn tapioca` | `sorbet/rbi/dsl/<ModelName>.rbi` |
| GraphQL type/field/query/mutation | `yarn codegen` | `app/javascript/GraphQLTypes.ts` |

## Merging PRs
When squash-merging an approved PR:
1. `gh pr merge {number} --squash --delete-branch` (merges and deletes remote+local branch)
2. `git checkout master && git pull` (switch to master and pull the merge)
3. Transition the Jira ticket to "Done" (TC project: transition ID 141, EPDSUPPORT: transition ID 91)
4. If no more open PRs remain, cancel the pr-monitor-poll cron job via CronDelete

## Task Planning
Do NOT start implementing immediately. Instead:
1. Clarify the goal — restate the problem
2. Identify options — present approaches with trade-offs
3. Discuss impact — what code, tests, systems are affected
4. Agree on approach — wait for confirmation before writing code
