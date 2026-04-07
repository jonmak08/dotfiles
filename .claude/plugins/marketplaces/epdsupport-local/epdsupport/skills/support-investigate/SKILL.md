---
name: support-investigate
description: "Deep-dive a specific EPDSUPPORT request — read the thread, query data, check logs, search code, and produce a structured investigation report. Use when user asks to investigate a support request, dig into a thread, or diagnose an issue."
argument-hint: "<slack-thread-url>"
allowed-tools:
  - mcp__slackgustoofficialmcp__slack_read_thread
  - mcp__tax-credits__execute_sql
  - mcp__tax-credits__explain_query
  - mcp__tax-credits__get_schema
  - mcp__datadoggusto__search_datadog_logs
  - mcp__datadoggusto__search_datadog_spans
  - mcp__githubgusto__search_code
  - mcp__githubgusto__search_issues
  - mcp__jiraconfluencegusto__getConfluencePage
  - mcp__jiraconfluencegusto__searchConfluenceUsingCql
  - Grep
  - Glob
  - Read
  - Write
---

# EPDSUPPORT Investigate

Deep-dive a specific support request from the EPDSUPPORT Slack channel.

## Steps

1. **Read the full Slack thread** using `mcp__slackgustoofficialmcp__slack_read_thread` with the provided thread URL. Read ALL messages in the thread, not just the root message — context from follow-up messages is critical for accurate diagnosis.

2. **Extract key identifiers:**
   - Company ID (look for numeric IDs, "company 12345")
   - Tax period / tax year
   - Error messages or stack traces
   - User email or name (for context only — never include in responses)
   - Timestamps of when the issue occurred

3. **Check the knowledge base** — read `references/known-issues.md` from the plugin directory. If the request matches a known pattern, note the match and confidence level.

4. **Check the Production Data Audit Log** via `mcp__jiraconfluencegusto__getConfluencePage` for page ID `68630871`. Search for similar issues in the audit log.

5. **Run targeted investigation based on the category** (classify using the same categories as triage):

   ### Data Lookup
   - Use `mcp__tax-credits__get_schema` to find relevant tables if unsure
   - Validate your query with `mcp__tax-credits__explain_query` BEFORE execution
   - Query `mcp__tax-credits__execute_sql` for company status, calculation results, tax period state
   - Reference `references/data-lookups.md` for common query patterns

   ### Error Diagnosis
   - Search Datadog logs via `mcp__datadoggusto__search_datadog_logs` for the company ID and/or error message, scoped to the timeframe around when the issue was reported
   - Query tax-credits SQL for data state (missing records, null fields, invalid status values)
   - Search the codebase with Grep/Glob for the error source (class name, method, error message)

   ### Bug Report
   - Search GitHub via `mcp__githubgusto__search_issues` for related issues or PRs
   - Search codebase via `mcp__githubgusto__search_code` and local Grep/Glob for the relevant component/service
   - Check Datadog logs to determine scope: is this one company or widespread?

   ### How-To
   - Search the codebase with Grep/Glob for the relevant feature, class, or method
   - Check `references/known-issues.md` for documented answers
   - Read relevant source files to understand the feature

   ### Operational
   - Check Datadog for service health via `mcp__datadoggusto__search_datadog_logs` (error rates, job failures)
   - Check Datadog spans via `mcp__datadoggusto__search_datadog_spans` for latency or timeout issues
   - Query SQL for stuck/failed records

6. **SQL safety rules:**
   - ALWAYS validate queries with `mcp__tax-credits__explain_query` before running `mcp__tax-credits__execute_sql`
   - The connection is read-only
   - Include all SQL executed in the terminal output so the on-call person can spot-check
   - NEVER include PII (emails, SSNs, names) in investigation reports or Slack responses — only include status, state, IDs, and timestamps

7. **Write the investigation report** to `tmp/support-investigate-<message-ts>.md` in the project root (where `<message-ts>` is the Slack message timestamp from the thread URL). This allows the respond skill to reuse results without re-investigating.

8. **Output the report to terminal** in this format:

```markdown
## Investigation: [Short description]

**Category:** [Data lookup | Error diagnosis | Bug report | How-to | Operational]
**Reported:** [time ago] by @[reporter]
**SQL executed:** [queries run, if any]

### Findings
- [finding 1]
- [finding 2]

### Root Cause
[root cause or "Unable to determine" if unknown]

### Suggested Fix
- Immediate: [quick fix]
- Long-term: [code/process change]

### Confidence: [HIGH | MEDIUM | LOW]
[Brief justification for confidence level]
```

## Confidence Assessment

Apply these rules in precedence order (first match wins):
1. Requires production console write access → **LOW**
2. No root cause found → **LOW**
3. Multiple possible explanations → **MEDIUM**
4. Root cause found but write action needed → **MEDIUM**
5. Exact match in known-issues.md → **HIGH**
6. Data lookup with clear results → **HIGH**
7. How-to with clear codebase answer → **HIGH**

## Graceful Degradation

If any MCP tool fails (timeout, permission error, etc.), do NOT stop the investigation. Report what you couldn't check and continue with available tools. Example: "Could not query Datadog logs (timeout). Proceeding with SQL and codebase analysis."
