---
name: support-detect
description: "Lightweight change detection for EPDSUPPORT channels. Reads channels, filters against state, invokes support-run only when new messages found. Designed as the cron entry point for /loop."
argument-hint: "[optional: 'support' (default), 'production', 'alerts', or 'all']"
allowed-tools:
  - mcp__slackgustoofficialmcp__slack_read_channel
  - Read
  - Write
  - Skill
---

# EPDSUPPORT Detect

Lightweight change detection for Tax Credits Slack channels. This is the cron entry point — runs every poll cycle, but only invokes the full triage/respond skill when new messages are found.

## Channels

| Channel | ID | Argument | Purpose |
|---|---|---|---|
| #taxcred-epd-support | `C05HVU79PQC` | `support` (default) | Team support requests |
| #taxcred-eng-alerts | `C04T7AE38RF` | `alerts` | Engineering alerts (Datadog + Sentry) |
| #taxcred-eng-alerts-production | `C05GYKXML7M` | `production` | Production alerts, Sentry triage reports |

Use `all` to poll all 3 channels.

## Steps

### 1. Read State File

Read `tmp/support-poll-state.json` in the current project root.

If the file is missing or corrupted (invalid JSON), treat it as empty and only process messages from the last 2 hours. Create a fresh state file with `processed: {}` and `last_poll` set to current ISO timestamp.

### 2. Select Channels

Based on the argument:
- `support` (default): Only read `C05HVU79PQC`
- `alerts`: Only read `C04T7AE38RF`
- `production`: Only read `C05GYKXML7M`
- `all`: Read all 3 channels

### 3. Read Channels

Read each selected channel using `mcp__slackgustoofficialmcp__slack_read_channel` with a 2-hour lookback window.

### 4. Filter Against State

For each top-level message (not a thread reply), check if its `ts` is already in the state's `processed` map. Skip messages that are already processed.

### 5. If No New Messages

Update `last_poll` in state. Exit silently — no output.

### 6. If New Messages Found

Write `tmp/support-poll-pending.json` with the list of new messages:

```json
[
  {
    "ts": "1234567890.123456",
    "channel_id": "C05HVU79PQC",
    "channel_name": "#taxcred-epd-support",
    "channel_type": "support",
    "text_preview": "What's the filing status for company 67890?",
    "author": "U027F65EXPW",
    "posted_at": "2026-04-10T20:00:00Z"
  }
]
```

`channel_type` is one of: `support`, `alerts`, `production`.

Update `last_poll` in state.

Then invoke the run skill:
```
Invoke the Skill tool with skill='support-run'.
```

Wait for run to complete before exiting.
