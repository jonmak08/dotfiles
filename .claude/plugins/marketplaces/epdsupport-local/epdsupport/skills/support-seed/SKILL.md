---
name: support-seed
description: "Bootstrap the EPDSUPPORT knowledge base by reading the Production Data Audit Log from Confluence and extracting known issues. Run once before first use, and periodically to pick up new entries."
allowed-tools:
  - mcp__jiraconfluencegusto__getConfluencePage
  - mcp__jiraconfluencegusto__searchConfluenceUsingCql
  - mcp__tax-credits__get_schema
  - Read
  - Write
  - AskUserQuestion
---

# EPDSUPPORT Seed

Bootstrap the knowledge base by reading existing documentation and extracting known issues.

## Steps

1. **Read the Production Data Audit Log** from Confluence using `mcp__jiraconfluencegusto__getConfluencePage` with page ID `68630871` (space: TC).

2. **Read the current known-issues.md** from `references/known-issues.md` in the plugin directory.

3. **Extract known issues** from the Confluence page. For each production issue or fix documented in the audit log:
   - Identify the pattern (error message, symptoms)
   - Identify the category (Data lookup, Error diagnosis, Bug report, How-to, Operational)
   - Extract the diagnosis steps
   - Extract the fix (immediate and long-term)
   - Assess confidence (most documented fixes are HIGH)

4. **Deduplicate** — check if the pattern already exists in known-issues.md (match on title or pattern keywords). Skip duplicates.

5. **Append new entries** to `references/known-issues.md` following the entry format:

   ```markdown
   ### [Short title]
   - **Pattern:** [keywords or error messages]
   - **Category:** [category]
   - **Diagnosis:** [steps to confirm]
   - **Fix:**
     - Immediate: [quick fix]
     - Long-term: [code/process change]
   - **Confidence:** HIGH
   ```

6. **Verify data-lookups.md queries** — use `mcp__tax-credits__get_schema` to check that the table and column names in `references/data-lookups.md` are correct. Update any incorrect queries.

7. **Report** what was added:
   ```
   EPDSUPPORT Seed complete:
   - Added N new entries to known-issues.md
   - Updated M queries in data-lookups.md
   - Skipped K duplicate entries
   ```

## When to Run

- Once before first use of the epdsupport skills
- Periodically (e.g., monthly) to pick up new Confluence entries
- After major incidents that result in new audit log entries
