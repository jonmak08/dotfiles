---
name: Post PR findings as inline comments
description: When posting review findings to PRs, use inline diff comments instead of general PR comments — fall back gracefully
type: feedback
---

When posting findings as PR comments, always try inline (diff-level) comments first, not general issue comments.

**Why:** General comments lose the file/line context that makes review feedback actionable. The user expects findings to appear inline on the diff, like a human reviewer would post them.

**How to apply:**
1. Fetch the diff to find which lines are in the diff hunks: `gh pr diff {number} --repo {repo}`
2. For each finding, check if the target line is in the diff. If yes, post as inline review comment using the Reviews API with the correct diff line number.
3. If the exact line isn't in the diff, find the nearest changed line in the same file and post there with a note like "Re: line {original_line} —" prefix.
4. If the file has no lines in the diff (shouldn't happen for findings), fall back to a file-level comment using `subject_type: "file"` and `path` only (no `line`).
5. Only as a last resort, use `gh pr comment` for a general PR comment.

GitHub Reviews API format for inline comments:
```
gh api repos/{owner}/{repo}/pulls/{number}/reviews \
  --method POST \
  --input - <<'EOF'
{"event": "COMMENT", "commit_id": "{sha}", "comments": [{"path": "file.rb", "line": {diff_line}, "body": "comment"}]}
EOF
```
