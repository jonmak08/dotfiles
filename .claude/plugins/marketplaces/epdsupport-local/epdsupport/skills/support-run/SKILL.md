---
name: support-run
description: "Triage and respond to new EPDSUPPORT messages from the handoff file. Reads threads, classifies messages, runs investigations, auto-responds or drafts. Invoked by support-detect."
allowed-tools:
  - mcp__slackgustoofficialmcp__slack_read_channel
  - mcp__slackgustoofficialmcp__slack_read_thread
  - mcp__slackgustoofficialmcp__slack_send_message
  - mcp__tax-credits__execute_sql
  - mcp__tax-credits__explain_query
  - mcp__tax-credits__get_schema
  - mcp__datadoggusto__search_datadog_logs
  - mcp__datadoggusto__search_datadog_spans
  - mcp__datadoggusto__search_datadog_monitors
  - mcp__datadoggusto__search_datadog_events
  - mcp__githubgusto__search_code
  - mcp__githubgusto__search_issues
  - mcp__jiraconfluencegusto__getConfluencePage
  - Grep
  - Glob
  - Read
  - Write
  - AskUserQuestion
---

# EPDSUPPORT Run

Triage and respond to new messages that support-detect identified. Reads the handoff file, checks threads, classifies messages, runs investigations, and auto-responds or drafts for review.

## References

Read these files from the plugin directory (`/Users/jon.mak/.claude/plugins/cache/epdsupport-local/epdsupport/0.1.0/`) before starting:
- `references/team-members.md` — Slack user IDs for team members (used to check if messages are answered)
- `references/known-issues.md` — known issue patterns for matching
- `references/response-templates.md` — response format templates

## Steps

### 1. Read Handoff File

Read `tmp/support-poll-pending.json` in the current project root.

- If missing: Output "No pending messages." and stop.
- If empty array: Output "No pending messages." and stop.

### 2. Check Threads and Filter Answered Messages

For each message in the handoff file, read its thread using `mcp__slackgustoofficialmcp__slack_read_thread`.

- If any thread reply (other than the original author and bots) is from a team member (per `references/team-members.md`): mark as "answered" — add to state's `processed` map with `action: "already-answered"` and skip.
- For alert channels: a PR link in the thread also counts as "acknowledged" — mark processed and skip.

Write state after each skip (crash-safe).

### 3. Triage Unanswered Messages

For each remaining unanswered message, classify by category and priority.

**Support categories** (for #taxcred-epd-support):
- **Data lookup** — status checks, calculation values
- **Error diagnosis** — something failed/broken, error messages
- **How-to** — questions about features or processes
- **Bug report** — user-facing errors, UI issues
- **Operational** — infra issues, stuck jobs, deployment

**Alert categories** (for #taxcred-eng-alerts and #taxcred-eng-alerts-production):
- **Error spike** — Sentry errors, exception counts
- **Infrastructure** — service health, deploy failures
- **Data integrity** — null violations, constraint errors
- **Job failure** — Sidekiq/Karafka failures
- **External dependency** — third-party API failures
- **Performance** — latency spikes, slow queries

**Support priority:** HIGH (blocking/production/urgent), MEDIUM (active work blocked, < 4h), LOW (general questions)

**Alert priority:** CRITICAL (> 1k events, data loss), HIGH (> 100 events, customer-facing), MEDIUM (< 100, non-prod), LOW (informational)

### 4. Respond to Support Messages

For each unanswered support channel message, run the respond flow:

1. **Investigate:** Extract identifiers (company ID, error message, etc.). Check `references/known-issues.md` for pattern match. If needed, run targeted queries (SQL via `mcp__tax-credits__execute_sql`, Datadog logs, GitHub code search).

2. **Assess confidence:**
   - Requires production console write → **LOW**
   - No root cause found → **LOW**
   - Multiple possible explanations → **MEDIUM**
   - Root cause found but write action needed → **MEDIUM**
   - Exact match in known-issues.md → **HIGH**
   - Data lookup with clear results → **HIGH**
   - How-to with clear codebase answer → **HIGH**

3. **Act based on confidence:**
   - **HIGH:** Auto-respond via Slack MCP using templates from `references/response-templates.md`. All responses use the standard header:
     ```
     :robot_face: *AI Generated Response*
     *Source:* <link> | *Priority:* {emoji} {level} | *Company:* {id} | *Env:* {env}
     ───────────────────────────
     [body]

     _Confidence: HIGH | If this doesn't look right, please flag and a team member will follow up._
     ```
   - **MEDIUM/LOW:** Print summary to terminal for human review

4. **Write state** after each response with `action: "auto-responded"` or `action: "drafted"` or `action: "escalated"`.

### 5. Handle Alert Messages

For unanswered alert channel messages: print a summary with classification and priority. Do NOT auto-respond — alerts are informational, humans decide what to act on.

For Datadog alerts (empty messages from `U01FS5LEAE4` in #taxcred-eng-alerts): query Datadog monitors directly using `mcp__datadoggusto__search_datadog_monitors` with `tag:"team:tax_credits" status:alert` and `status:warn`.

For automated triage reports in #taxcred-eng-alerts-production: parse the structured report and classify individual items. Focus on "Code-Fixable" items without PRs.

Deduplicate by Sentry Short ID across channels.

### 6. Safety Limits

- **Max 3 auto-responses per cycle** — only for #taxcred-epd-support. If more HIGH-confidence messages exist, draft the rest for human review.
- **No auto-responses for alert channels.**
- **Write state after each response** — crash-safe deduplication.

### 7. Output Summary

```
EPDSUPPORT Poll — N new messages

[#taxcred-epd-support]
Auto-responded: "Filing status for company 67890" (HIGH confidence)
Needs review: "Company 12345 calculation failed" (MEDIUM confidence)
   Draft: [draft text]
   Thread: <link>

[#taxcred-eng-alerts-production]
NEW: [HIGH] Error spike — "TypeError in SendFulfillmentStatus" (MITHRIN-RAILS-33Z)
   Thread: <link>

Datadog monitors: All OK
```

If no unanswered messages remained after thread filtering: output "No unanswered messages."

### 8. Clean Up

Delete `tmp/support-poll-pending.json`.

## Important Rules

- NEVER include PII in Slack responses (emails, SSNs, names)
- Only include status, state, IDs, timestamps, and error messages
- Always include the confidence footer in Slack responses
- If Slack send fails, always fall back to terminal draft — never silently fail
