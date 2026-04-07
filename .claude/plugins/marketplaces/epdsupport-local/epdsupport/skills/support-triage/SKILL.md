---
name: support-triage
description: "Read the EPDSUPPORT Slack channel and classify unanswered messages. Use when user asks to triage support, check EPDSUPPORT, see what's unanswered, or review the support queue."
argument-hint: "[optional: number of hours to look back, default 24]"
allowed-tools:
  - mcp__slackgustoofficialmcp__slack_read_channel
  - mcp__slackgustoofficialmcp__slack_read_thread
  - Read
  - AskUserQuestion
---

# EPDSUPPORT Triage

Read the EPDSUPPORT Slack channel (`C05HVU79PQC`) and classify unanswered messages by category and priority.

## Steps

1. **Read team member list** from `references/team-members.md` in the plugin directory. These Slack user IDs identify team members whose messages are excluded from triage and whose thread replies mark a message as "answered."

2. **Read recent channel messages** using `mcp__slackgustoofficialmcp__slack_read_channel` for channel `C05HVU79PQC`. Default lookback is 24 hours, or use the argument if provided.

3. **For each top-level message** (not a thread reply):
   - If the message author is a team member, skip it.
   - Read the thread using `mcp__slackgustoofficialmcp__slack_read_thread` to check for replies.
   - If any thread reply is from a team member (per the team-members list), the message is "answered" — skip it.
   - This requires O(n) Slack API calls, which is acceptable for a support channel's volume.

4. **For each unanswered message**, read the full thread context (not just the root message) and classify:

   **Categories:**
   - **Data lookup** — status checks, calculation values, "what is the status of..."
   - **Error diagnosis** — something failed/broken, error messages, "calculation failed"
   - **How-to** — questions about features or processes, "how do I..."
   - **Bug report** — user-facing errors, UI issues, "seeing an error on..."
   - **Operational** — infra issues, stuck jobs, deployment, "jobs are stuck"

5. **Assign priority** based on urgency signals:
   - **HIGH** — "blocking", "production", "urgent", customer impact, data loss
   - **MEDIUM** — active work blocked, recent (< 4 hours), specific error
   - **LOW** — general questions, older messages, no urgency signals

6. **Output a prioritized summary table** sorted by priority then recency:

```
N unanswered messages in EPDSUPPORT:

1. [HIGH] Error diagnosis — "Company 12345 calculation failed with NoMethodError"
   Thread: <link>  |  Posted: 2h ago

2. [MED] Data lookup — "What's the filing status for company 67890?"
   Thread: <link>  |  Posted: 4h ago

3. [LOW] How-to — "How do I trigger a recalculation for a specific tax period?"
   Thread: <link>  |  Posted: 6h ago
```

If no unanswered messages, output: "No unanswered messages in EPDSUPPORT."
