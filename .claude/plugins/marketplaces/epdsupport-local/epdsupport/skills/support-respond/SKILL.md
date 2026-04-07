---
name: support-respond
description: "Draft or post a response to an EPDSUPPORT request based on investigation. Auto-responds for high-confidence cases, drafts for human review otherwise. Use when user asks to respond to a support request, answer a thread, or handle a support message."
argument-hint: "<slack-thread-url>"
allowed-tools:
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

# EPDSUPPORT Respond

Draft or post a response to an EPDSUPPORT Slack thread based on investigation results.

## Steps

1. **Extract the message `ts` from the thread URL.** The Slack thread URL contains the message timestamp (e.g., `p1234567890123456` → `1234567890.123456`).

2. **Check for existing investigation report** at `tmp/support-investigate-<message-ts>.md` in the project root. If found, read it. If not found, run the full investigation (follow the same steps as the investigate skill — read the thread, extract identifiers, check knowledge base, query tools).

3. **Read response templates** from `references/response-templates.md` in the plugin directory.

4. **Assess confidence** using the same precedence rules as the investigate skill:
   1. Requires production console write access → **LOW**
   2. No root cause found → **LOW**
   3. Multiple possible explanations → **MEDIUM**
   4. Root cause found but write action needed → **MEDIUM**
   5. Exact match in known-issues.md → **HIGH**
   6. Data lookup with clear results → **HIGH**
   7. How-to with clear codebase answer → **HIGH**

5. **Act based on confidence:**

   ### HIGH Confidence — Auto-respond
   - Compose the response using the appropriate template from `references/response-templates.md`
   - Wrap in the standard format:
     ```
     *Investigated by TC Support Bot*

     [body]

     _Confidence: HIGH | If this doesn't look right, please flag and a team member will follow up._
     ```
   - Post to the Slack thread using `mcp__slackgustoofficialmcp__slack_send_message`
   - If the send fails (permission error, API error), fall back to printing the draft for manual posting
   - Report: "Auto-responded to thread [link]"

   ### MEDIUM Confidence — Draft for review
   - Compose the response using templates
   - Print the draft to terminal
   - Ask the user: "Post this response? (y/n/edit)"
   - If yes: post via Slack MCP
   - If edit: let the user modify, then post
   - If no: skip

   ### LOW Confidence — Escalate
   - Compose an escalation summary using the escalation template
   - Identify the relevant domain area based on Packwerk pack structure (search `packs/` for the relevant domain — do NOT use git blame as it's unreliable)
   - Print the draft to terminal
   - Ask: "Post this escalation? (y/n/edit)"

6. **Knowledge base update prompt:** After responding (regardless of confidence), ask: "Save this pattern to known-issues.md for future auto-responses? (y/n)"
   - If yes: append a new entry to `references/known-issues.md` following the entry format documented in that file
   - Include: pattern, category, diagnosis steps, fix, confidence level

## Important Rules

- NEVER include PII in Slack responses (emails, SSNs, names)
- Only include status, state, IDs, timestamps, and error messages
- Always include the confidence footer in Slack responses
- If Slack send fails, always fall back to terminal draft — never silently fail
