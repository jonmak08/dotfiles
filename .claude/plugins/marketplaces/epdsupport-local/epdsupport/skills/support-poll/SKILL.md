---
name: support-poll
description: "Periodically check EPDSUPPORT for new unanswered messages and auto-triage/respond. Designed for use with /loop (requires superpowers plugin). Use when user asks to monitor support, watch the channel, or set up polling."
argument-hint: "[optional: number of hours to look back, default 2]"
allowed-tools:
  - mcp__slackgustoofficialmcp__slack_read_channel
  - mcp__slackgustoofficialmcp__slack_read_thread
  - mcp__slackgustoofficialmcp__slack_send_message
  - mcp__tax-credits__execute_sql
  - mcp__tax-credits__explain_query
  - mcp__tax-credits__get_schema
  - mcp__datadoggusto__search_datadog_logs
  - mcp__datadoggusto__search_datadog_spans
  - mcp__githubgusto__search_code
  - mcp__githubgusto__search_issues
  - mcp__jiraconfluencegusto__getConfluencePage
  - Grep
  - Glob
  - Read
  - Write
  - AskUserQuestion
---

# EPDSUPPORT Poll

Periodic monitoring of the EPDSUPPORT Slack channel. Designed for use with `/loop` (requires the superpowers plugin):

```
/loop 10m /support-poll
```

## Steps

1. **Read the state file** at `tmp/support-poll-state.json` in the project root. This file tracks which messages have already been processed, keyed by Slack message `ts` (unique message ID).

   If the state file is missing or corrupted (invalid JSON), treat it as empty and only process messages from the last 2 hours — do NOT process the full channel history. Create a fresh state file.

   State file format:
   ```json
   {
     "processed": {
       "1234567890.123456": { "action": "auto-responded", "at": "2026-03-24T10:00:00Z" },
       "1234567891.123456": { "action": "drafted", "at": "2026-03-24T10:05:00Z" }
     },
     "last_poll": "2026-03-24T10:00:00Z"
   }
   ```

2. **Run triage** — follow the same steps as the triage skill (read channel, check threads, filter unanswered, classify). Use a 2-hour lookback window by default.

3. **Filter out already-processed messages** — skip any message whose `ts` is already in the state file.

4. **For each new unanswered message**, run the respond flow:
   - Follow the same steps as the respond skill (investigate, assess confidence, compose response)
   - **HIGH confidence:** auto-respond via Slack MCP. **Maximum 3 auto-responses per poll cycle** to bound blast radius in case of state file loss.
   - **MEDIUM/LOW confidence:** print a summary to terminal for the on-call person. Do NOT auto-respond.

5. **Write to state file after EACH individual response** (not at the end of the cycle). This prevents re-processing on crash. Use the message `ts` as the key.

6. **Output summary:**
   - If no new messages: output nothing (silent)
   - If new messages found:
     ```
     EPDSUPPORT Poll — N new messages

     Auto-responded: "Filing status for company 67890" (HIGH confidence)
     Needs review: "Company 12345 calculation failed" (MEDIUM confidence)
        Draft: [draft text]
        Thread: <link>
     ```

## Safety Limits

- **Max 3 auto-responses per cycle** — if more HIGH-confidence messages exist, draft the rest for human review
- **2-hour lookback on state reset** — prevents processing the entire channel history
- **Write state after each response** — crash-safe deduplication
