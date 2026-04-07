---
name: PR comment resolve workflow
description: When addressing PR review comments, always react with thumbs up and resolve the thread
type: feedback
---

When addressing a PR review comment: after replying, also add a thumbs up (+1) reaction to the original comment and resolve the review thread.

**Why:** User expects the full PR comment workflow — reply, react, resolve — not just the reply. Leaving threads unresolved creates noise for reviewers.

**How to apply:** After using `add_reply_to_pull_request_comment`, also:
1. Add a +1 reaction via `gh api repos/{owner}/{repo}/pulls/comments/{commentId}/reactions -f content="+1"`
2. Find the thread ID via GraphQL `reviewThreads` query filtered by the comment
3. Resolve the thread via `resolveReviewThread` mutation
