---
name: Slack message header format
description: Standard header for all AI-posted Slack messages — use :robot_face: *AI Generated Response* every time
type: feedback
---

All Slack messages posted by Claude must use this header:

```
:robot_face: *AI Generated Response*
*Source:* <link> | *Priority:* :large_orange_circle: HIGH | *Company:* 12345 | *Env:* production
───────────────────────────
[body]
```

**Why:** User wants a consistent, recognizable header on all AI-generated Slack posts. Updated from the previous "AI Assistant (auto-generated)" wording.

**How to apply:** Use this header on every Slack message sent via MCP, regardless of which skill or workflow triggers it. Omit Company/Env fields when not applicable. Priority emoji: :red_circle: CRITICAL, :large_orange_circle: HIGH, :large_yellow_circle: MEDIUM, :white_circle: LOW.
