# Coding Standards

## Analysis Approach (Scientific Method)
- Distinguish between theories, hypotheses, and proven facts
- Never claim "solved" or "root cause found" without concrete evidence
- Use language like "theory," "hypothesis," "possible explanation" for unproven ideas
- Acknowledge uncertainty when multiple theories exist
- If investigation hits a dead end, acknowledge it rather than forcing conclusions

## General Principles
- Always prefer simple solutions
- Avoid code duplication — check existing codebase first
- Focus on areas relevant to the task; don't touch unrelated code
- Think about what other methods/areas might be affected by changes
- Avoid major architecture changes to working features unless explicitly instructed

## Code Quality
- Avoid files over 200-300 lines — refactor at that point
- No trailing spaces
- When fixing a bug, exhaust existing implementation options before introducing new patterns
- If introducing a new pattern, remove the old implementation
- Avoid one-off scripts in files
- Never mock data in application code (only in tests)
- Never overwrite .env without asking first
- All files must end with a single newline (POSIX, Danger rule)

## Nil/Null Safety (common review feedback)
- Use nil-safe comparisons: `!= 'Yes'` instead of `== 'No'` when field can be nil
- Add explicit null guards before property access (e.g., `taxPeriodFilingSurvey != null`)
- Display 'N/A' or explicit fallback instead of blank when values are nil
- When removing API fields, older payload versions may still send them — don't delete handlers

## Ruby Patterns (from PR reviews)
- Use `prepend: true` on `before_destroy` callbacks — ensures they run before `dependent: :destroy`
- AASM bang methods (e.g., `mark_as_unlost!`) already wrap in transactions — don't add redundant `ActiveRecord::Base.transaction`
- Understand framework behavior before adding defensive code (e.g., rake task `JSON.parse` already handles type casting)
- Use existing test helpers (e.g., `pretend_not_test_in_discretion` in `spec/helpers.rb`)
- Back model uniqueness validations with DB unique indexes — without them, race conditions can bypass the check
- Check production data before adding model validations — new constraints can break updates to existing records
- Don't compare floats with BigDecimal directly — use `.to_d` or compare with explicit precision
- Wrap external/risky calls with `rescue` + `Sentry.capture_exception` — don't swallow errors silently
- Never include PII (emails, names) in error messages or log output

## Frontend Patterns (from PR reviews)
- Always check GraphQL mutation `success` field before writing to Apollo cache
- Add `onError` handlers to GraphQL queries — without them, errors leave `data` as `undefined`, trapping users on loading screens
- Handle race conditions between multiple independent queries loading at different times
- Use `useMemo` for computed validation schemas
- Use explicit ID checking over positional array slicing (e.g., `col.id !== 'name'` not `columns.slice(1)`)
- Use semantic Workbench design tokens for colors (e.g., `color="neutral.tertiary.icon"`)
- Add `useQuery<GeneratedType>()` type parameters for type safety
- Use Workbench components (`Img`, `Button`, `IconButton`) instead of native HTML elements
- Every new React component needs a `.test.tsx` file

## PII / FullStory
- Mask PII with `fs-mask` class in FullStory-unmasked containers
- Audit from data source (ar_docs `sensitive: true` fields) outward, not from UI inward
- File names can contain PII — mask upload file name displays

## Backward Compatibility During Migrations
- Don't remove backend GraphQL fields until frontend changes are deployed
- Maintain dual-writes during column migrations (old + new location)
- Add column defaults in migrations (e.g., `default: false`) rather than leaving nil

## Environment Considerations
Write code aware of different environments:
- Production: credits.gusto.com, RAILS_ENV=production
- Non-prod: staging/test-[1-7]/demo.credits.gusto.com, RAILS_ENV=production
- Test: RAILS_ENV=test (RSpec)
- Local: localhost:3003, RAILS_ENV=development

## Shell Commands
- Don't assume CLI tools exist in containers
- Use basic POSIX-compliant commands when possible
- Test with fallbacks (cmd || echo "cmd failed")

## Feature Flags
- Check for existing Flipper flags before creating new ones — reuse when the gate covers your use case
- Keep PR description in sync with the actual flags used in code
- Document flag lifecycle (when it should be removed)

## Testing Patterns (from 102 review comments — #1 most common feedback)
- Every new code path needs a corresponding spec — don't rely on integration tests alone
- Use `travel_to` with fixed times for time-dependent tests — `Time.current` causes flaky tests
- Test all conditional branches, not just the happy path
- New GraphQL mutations need a dedicated spec file

## Sidekiq Testing
- Prefer `perform_async` and `drain` over `new.perform` in tests
- Use `SomeJob.jobs` to verify enqueued jobs (clear with `.jobs.clear` first)
- Don't stub `perform_async`

## Sorbet
- Never auto-add Sorbet typing annotations unless explicitly requested

## Project-Specific: R&D Tax Credits Estimates
- `TaxCredits::Rd::RatioEstimateGenerator` computes QREs, looks up NAICS ratio, upserts `TaxCreditsRatioEstimate`
- `ArdiusIntegration::Estimate::ProcessEstimateService` handles persisting Ardius ML estimate records
- `CreditEstimateCalculator` params:
  - `force_recompute_latest` (default false) — only true for repair/backfill/admin actions
  - `skip_ratio_estimate_generation` (default false) — true when ratio generation handled elsewhere
- `RecomputeRdCreditEstimateWorker` goes on `Within1Hour` queue
- Bulk backfill jobs go on `Within12Hours` queue
