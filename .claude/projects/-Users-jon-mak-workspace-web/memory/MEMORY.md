# Memory

## Commit message format
- Use conventional commit format tied to the branch/ticket: `fix(TICKET-ID): description`
- Example from EPDSUPPORT-3965 branch: `fix(EPDSUPPORT-3965): Deduplicate useTaxCreditEstimate hook calls`
- Always match the ticket ID from the current branch name

## Addressing PR review comments
When addressing a PR comment, always do ALL of these steps:
1. Make the code change
2. Commit and push
3. Add a 👍 reaction to the original comment
4. Reply to the comment explaining the fix
5. Resolve the review thread (use GraphQL `resolveReviewThread` mutation with the thread ID, not the comment ID)
