---
name: Redash API Key Setup
description: REDASH_KEY env var should be set from REDASH_API_KEY environment variable for Redash queries
type: reference
---

When running Redash queries, set `REDASH_KEY` from the existing `REDASH_API_KEY` environment variable:

```bash
export REDASH_KEY="$REDASH_API_KEY"
```
