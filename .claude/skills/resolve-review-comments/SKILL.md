---
name: resolve-review-comments
description: "Use when addressing PR review feedback, resolving comment threads, and re-requesting review after making changes. Triggers: 'address review comments', 'resolve PR feedback', 'fix review comments', 'update PR after review'."
---

# Resolve Review Comments

## Overview

Step-by-step workflow for addressing PR review feedback: make changes, push, reply with commit SHAs, resolve threads, and re-request review.

## When to Use

- Reviewer left comments on your PR and you need to address them
- You've made changes in response to review feedback and need to close out threads
- PR has unresolved conversations that need to be resolved after fixes

## Workflow

### 1. Read Review Comments

Fetch all pending review comments:

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments
gh api repos/{owner}/{repo}/pulls/{number}/reviews
```

Understand each comment before making changes. Group related comments that can be addressed together.

### 2. Make Changes and Commit

- Address each comment with a focused commit
- Use clear commit messages referencing what was changed: `fix(TICKET-ID): description`
- Separate feature changes from refactors into distinct commits
- Each commit should be atomic and reviewable

### 3. Push Changes

```bash
git push
```

### 4. Reply to Each Comment Thread

For each resolved comment, reply with the specific commit SHA that addresses it:

> Fixed in abc1234

**Important:** Do not wrap commit SHAs in backticks — GitHub auto-links raw hashes. Backticks prevent this.

### 5. React to Original Comments

Add a thumbs up (+1) reaction to each original reviewer comment to signal acknowledgment.

### 6. Resolve Threads

Resolve each addressed comment thread via the GraphQL `resolveReviewThread` mutation. Fetch the thread ID from the PR review threads first.

### 7. Re-request Review

After all comments are addressed:

```bash
gh pr edit {number} --add-reviewer {reviewers}
```

Use the project's default reviewer list.

## Common Mistakes

- Wrapping commit SHAs in backticks (breaks GitHub auto-linking)
- Forgetting to re-request review after pushing changes
- Addressing multiple unrelated comments in a single commit (makes review harder)
- Resolving threads without replying first (reviewer loses context on what changed)
