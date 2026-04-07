---
name: Slack AI Header Convention
description: All Slack messages posted by Claude must include a bold AI Generated Response header with robot emoji and horizontal rule
type: feedback
---

Any response from Claude posted to Slack must start with a header: **:robot_face: AI Generated Response** (all bold) followed by a horizontal rule (———), then the message body below.

**Why:** User wants clear attribution that a message was AI-generated so Slack readers know it came from Claude, not a human.

**How to apply:** Prepend this header to every Slack message sent via `mcp__slackgustoofficialmcp__slack_send_message` or `mcp__slackgustoofficialmcp__slack_send_message_draft`. This applies to all channels and threads, not just EPDSUPPORT. Use double line breaks (blank line) between paragraphs for proper spacing in Slack.
