---
name: PR table column and format preferences
description: PR table format — single linked PR column (no # prefix), Comments, My Review columns; no AI Review column
type: feedback
---

When displaying open PR summary tables:
1. Use a single "PR" column with the number linked to the PR URL (e.g., `[6234](url)`) — no separate "#" column, no `#` prefix on the number
2. Drop the "Reviewed" / "AI Review" column — the poll reviews everything automatically so it's always "Yes"
3. Add a "Comments" column showing which humans have posted review comments (e.g., "Richard, Dennis" or "—" if none)
4. Add a "My Review" column showing whether Jon (jonmak08) has posted any review comments — "Yes" or "No"

Columns in order: PR, Title, Author, Comments, My Review

**Why:** User wants a compact table. The separate # column was redundant with PR. The `#` prefix adds noise. AI review was always "Yes" and not useful.

**How to apply:** Fetch reviewer comments via `gh api` when building the PR table. Display commenter first names in "Comments" column. Check if `jonmak08` appears in the commenters for "My Review". Use the team member mapping: jonmak08=Jon, dchandc=Dennis, rjnienaber-gusto=Richard, krishna-donepudi=Krishna, michjun=Michelle, jlee1201=John, scottland104=Scott, RyanDimitriRamos=Dimitri, carey-goldman=Carey, fengb=Benjamin.
