# Memory Index

## Project: Mithrin (R&D Tax Credits)

### Key Files
- [pr-and-review-workflow.md](pr-and-review-workflow.md) — PR reviewers, commit format, code review checklist, auto-generated files
- [coding-standards.md](coding-standards.md) — Coding patterns, workflow preferences, analysis approach
- [epdsupport.md](epdsupport.md) — EPDSUPPORT plugin operational notes
- [feedback_slack_header.md](feedback_slack_header.md) — All Slack messages must use `:robot_face: *AI Generated Response*` header
- [feedback_pr_reviewers.md](feedback_pr_reviewers.md) — Full PR checklist: add reviewers, transition Jira, use PR template

### Plugins
- **pr-monitor** — PR comment monitoring and team code review
  - Marketplace: `~/.claude/plugins/marketplaces/pr-monitor-local/pr-monitor/`
  - Cache: `~/.claude/plugins/cache/pr-monitor-local/pr-monitor/0.2.0/`
  - Skills (naming convention: `{domain}-{action}`):
    - `pr-comments-check` (interactive) — check your PRs for new comments
    - `pr-comments-poll` (for `/loop`) — poll your PRs for new comments
    - `pr-review-check` (interactive) — review team PRs with 5-round review (includes comment overlap detection)
    - `pr-review-poll` (for `/loop`) — auto-review new/updated team PRs (includes comment overlap detection)
    - `pr-review-seed` — bootstrap review knowledge base from 6 months of PR comments
  - Slack DM channel: `D028VDCC1EJ`
  - State files: `tmp/pr-monitor-state.json` (comments), `tmp/team-review-state.json` (reviews), `tmp/pr-reviews/review-patterns.md` (seeded knowledge base)
  - Config: `tmp/team-review-config.json`
  - Sound: play `Glass.aiff` (`afplay /System/Library/Sounds/Glass.aiff`) only when new comments/concerns detected
  - Slack DMs don't trigger notifications — sound is the primary alert mechanism
  - Run polls as subagent (Agent tool) to hide tool call noise from terminal
  - Mithrin repo is `ardiustech/mithrin` (not `Gusto/mithrin`)
- **epdsupport** — EPDSUPPORT Slack channel automation (see [epdsupport.md](epdsupport.md))
  - Cache: `~/.claude/plugins/cache/epdsupport-local/epdsupport/0.1.0/`
  - Skills (naming convention: `{domain}-{action}`):
    - `support-triage` — triage EPDSUPPORT channel
    - `support-investigate` — deep-dive a support request
    - `support-respond` — draft/post response
    - `support-poll` (for `/loop`) — periodic check for new messages
    - `support-seed` — bootstrap knowledge base
    - `alert-triage` — triage engineering alerts
    - `alert-investigate` — deep-dive an alert

### Skill Naming Convention
All skills follow `{domain}-{action}` pattern:
- `pr-comments-*` — monitoring comments on your PRs
- `pr-review-*` — reviewing team PRs (5-round code review)
- `support-*` — EPDSUPPORT channel work
- `alert-*` — engineering alert work
- Actions: `poll`, `check`, `triage`, `investigate`, `respond`, `seed`

### Keeping Rules in Sync
- `.cursor/rules/` and Claude memory files (`pr-and-review-workflow.md`, `coding-standards.md`) must stay in sync
- When updating one, update the other to match
- The EPDSUPPORT plugin skills at `/Users/jon.mak/.claude/plugins/cache/epdsupport-local/epdsupport/0.1.0/skills/` should also stay consistent with any related Cursor rules

### Atlassian
- Cloud ID: `3fd33630-4e39-4689-ad04-db32e3843117`
- Jon Mak Jira account ID: `60fee35aec92ab0070559e0d`
- EPDSUPPORT transitions: Backlog=11, Needs Investigation=21, Tabled=31, Won't Do=41, Selected for Dev=51, Dev In Progress=61, In Review=71, Ready for QA=81, Done=91
- TC project transitions: New=11, Defining Requirements=21, Ready for Sprint Planning=61, Won't Do=81, Ready for Development=91, Paused/Blocked=101, Dev In Progress=111, In Review=121, Ready for QA=131, Done=141
